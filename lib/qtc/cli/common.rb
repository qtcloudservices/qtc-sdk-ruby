require 'inifile'
module Qtc
  module Cli
    module Common

      def instance_info(instance_id)
        instance_data = platform_client.get("/instances/#{instance_id}")
        if instance_data
          response = platform_client.get("/instances/#{instance_id}/authorizations")
          if response['results']
            instance_data['authorizations'] = response['results']
          end
        else
          abort("Error: instance not found")
        end

        instance_data
      end

      def platform_client(token = nil)
        inifile['platform']['token'] = token unless token.nil?
        unless inifile['platform']['token']
          raise ArgumentError.new("Please login first using: qtc-cli login")
        end

        if @platform_client.nil?
          @platform_client = Qtc::Client.new(platform_base_url, {'Authorization' => "Bearer #{inifile['platform']['token']}"})
        end

        @platform_client
      end

      def ini_filename
        File.join(Dir.home, '/.qtc_client')
      end

      def inifile
        if @inifile.nil?
          if File.exists?(ini_filename)
            @inifile = IniFile.load(ini_filename)
          else
            @inifile = IniFile.new
          end
        end

        @inifile
      end

      ##
      # @param [String,NilClass]
      # @return [String]
      def extract_app_in_dir(remote = nil)
        if File.exists?(File.expand_path('./.git/config'))
          remotes = []
          git_remotes = `git remote -v`
          git_remotes.lines.each do |line|
            if match = line.match(/#{remote}\s+git@git-mar-(.*)\:(.*) \(push\)/)
              remotes << match[2]
            end
          end
          apps = remotes.uniq
          if apps.size == 1
            return apps[0]
          elsif apps.size > 1
            raise ArgumentError.new("Multiple app git remotes\nSpecify app with --remote REMOTE or --app APP")
          end
        end
      end

      ##
      # @return [Qtc::Client]
      def client
        if @client.nil?
          @client = Qtc::Client.new(base_url)
        end

        @client
      end

      def base_url
        ENV['QTC_MAR_URL'] || 'https://mar-eu-1.qtc.io/v1'
      end

      def platform_base_url
        ENV['QTC_PLATFORM_URL'] || 'https://api.qtc.io/v1'
      end
    end
  end
end
