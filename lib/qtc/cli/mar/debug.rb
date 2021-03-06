require_relative 'base'
require 'open3'

module Qtc
  module Cli
    class Mar::Debug < Mar::Base

      def local_debug(commands, options)
        app_home = File.realpath('.')
        stack = options.stack || 'cedar-14'
        branch = options.branch || 'master'
        puts "-----> Starting to build MAR app locally"
        puts "       Using stack: #{stack}"
        puts "       Using git branch: #{branch}"

        if options.clean == true && File.exists?("#{app_home}/slug.tgz")
          File.delete("#{app_home}/slug.tgz")
        end

        unless File.exists?("#{app_home}/slug.tgz")
          build_slug(app_home, stack, branch)
        else
          puts "       Existing slug.tgz found, build not needed."
        end
        puts "-----> Starting app container"
        run_opts = [
          '-e PORT=5000',
          "-e STACK=#{stack}",
          '-e SLUG_URL=file:///tmp/fake_slug.tgz',
          '-p 5000',
          "-v #{app_home}/slug.tgz:/tmp/fake_slug.tgz"
        ]
        if File.exists?("#{app_home}/.env")
          run_opts << "--env-file=#{app_home}/.env"
        end
        if commands.size == 0
          cmd = 'start web'
        else
          cmd = commands.join(" ")
        end

        exec("docker run -it #{run_opts.join(" ")} qtcs/slugrunner:#{stack} #{cmd}")
    end

    def local_build_slug(options)
      stack = options.stack || 'cedar-14'
      branch = options.branch || 'master'
      app_home = File.realpath('.')
      puts "-----> Starting to build MAR app locally"
      puts "       Using stack: #{stack}"
      puts "       Using git branch: #{branch}"
      build_slug(app_home, stack, branch)
    end

    def build_slug(app_home, stack, branch)
      docker_id = nil
      run_opts = [
          '-i',
          '-a stdin'
      ]
      if File.exists?("#{app_home}/.env")
        run_opts << "--env-file=#{app_home}/.env"
      end
      Open3.popen3("git archive #{branch} | docker run #{run_opts.join(' ')} qtcs/slugbuilder:#{stack}") {|stdin, stdout, stderr, wait_thr|
        stdin.close
        docker_id = stdout.gets
        if docker_id
          docker_id.strip!
        else
          puts stderr.gets
        end
        exit_status = wait_thr.value
        unless exit_status.success?
          raise "ERROR: build failed to start"
        end
      }
      Open3.popen2('docker', 'attach', docker_id){|stdin, stdout, wait_thr|
        stdin.close
        while line = stdout.gets
          puts line
        end
        exit_status = wait_thr.value
        unless exit_status.success?
          raise "ERROR: build failed to complete"
        end
      }
      puts "-----> Extracting slug from build image to ./slug.tgz"
      system("docker cp #{docker_id}:/tmp/slug.tgz . > /dev/null")

      docker_id
    rescue => exc
      system("docker rm -f #{docker_id}") if docker_id
      raise exc
    end
    end
  end
end
