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

      def platform_client
        raise ArgumentError.new('QTC_TOKEN environment variable is not set (you can get it from https://console.qtcloudservices.com)') unless ENV['QTC_TOKEN']

        if @platform_client.nil?
          @platform_client = Qtc::Client.new(platform_base_url, {'Authorization' => "Bearer #{ENV['QTC_TOKEN']}"})
        end

        @platform_client
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