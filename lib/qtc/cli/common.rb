require 'inifile'
module Qtc
  module Cli
    module Common

      attr_accessor :datacenter_id

      def instance_info(instance_id)
        instance_data = platform_client.get("/instances/#{instance_id}")
        unless instance_data
          abort("Error: instance not found")
        end

        instance_data
      end

      def current_cloud_id
        unless @current_cloud_id
          unless inifile['platform']['current_cloud']
            raise ArgumentError.new("Please specify used cloud first: qtc-cli clouds:use <id>")
          end
          @current_cloud_id = inifile['platform']['current_cloud']
          self.datacenter_id = inifile['platform']['current_dc']
        end
        @current_cloud_id
      end

      def current_cloud_dc
        unless @current_cloud_dc
          unless inifile['platform']['current_cloud']
            raise ArgumentError.new("Please specify used cloud first: qtc-cli clouds:use <id>")
          end
          @current_cloud_dc = inifile['platform']['current_dc']
        end
        @current_cloud_dc
      end

      def current_cloud_token
        token = nil
        begin
          authorizations = platform_client.get("/accounts/#{current_cloud_id}/authorizations")
          unless authorizations['results'][0]
            platform_client.post("/accounts/#{current_cloud_id}/authorizations", {})
            raise StandardError.new "retry"
          end
          token = authorizations['results'][0]['access_token']
        rescue ArgumentError => e
          raise e
        rescue
          retry
        end

        token
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

        unless @inifile['platform']
          @inifile['platform'] = {}
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

      def platform_base_url
        ENV['QTC_PLATFORM_URL'] || 'http://api.qtc.dev:4000/v1'
      end
    end
  end
end
