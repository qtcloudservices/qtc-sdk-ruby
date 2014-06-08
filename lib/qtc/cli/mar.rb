module Qtc
  module Cli
    class Mar < Thor

      desc 'show INSTANCE_ID', 'Show runtime information'
      def show(instance_id)
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          result = client.get("/apps/#{instance_id}", nil,  {'Authorization' => "Bearer #{token}"})
          puts result
        end
      end

      desc 'scale INSTANCE_ID process=count', 'Scale processes'
      def scale(instance_id, *types)
        scale = {}
        types.each do |type|
          arr = type.strip.split("=")
          if arr[0] && arr[1]
            scale[arr[0]] = arr[1].to_i
          end
        end
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          client.post("/apps/#{instance_id}/scale", scale, {}, {'Authorization' => "Bearer #{token}"})
        end
      end

      desc 'env INSTANCE_ID FOO=bar', 'Set runtime environment variables'
      def env(instance_id, *vars)
        env_vars = {}
        vars.each do |type|
          arr = type.strip.split("=")
          if arr[0] && arr[1]
            env_vars[arr[0]] = arr[1].to_i
          end
        end
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          if env_vars.keys.size > 0
            client.put("/apps/#{instance_id}/env_vars", env_vars, {}, {'Authorization' => "Bearer #{token}"})
          else
            puts client.get("/apps/#{instance_id}/env_vars", {}, {'Authorization' => "Bearer #{token}"})
          end
        end
      end

      desc 'logs', 'show app logs'
      option :offset
      option :limit
      def logs(instance_id)
        offset = options[:offset] || 0
        limit = options[:limit] || 100

        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          result = client.get("/apps/#{instance_id}/logs", {offset: offset, limit: limit}, {'Authorization' => "Bearer #{token}"})
          result['results'].each do |r|
            puts r['log']
          end
        end
      end

      private

      def instance_info(instance_id)
        instance_data = platform_client.get("/instances/#{instance_id}")
        if instance_data
          response = platform_client.get("/instances/#{instance_id}/authorizations")
          if response['results']
            instance_data['authorizations'] = response['results']
          end
        end

        instance_data
      end

      def platform_client
        if @platform_client.nil?
          @platform_client = Qtc::Client.new(platform_base_url, {'Authorization' => "Bearer #{ENV['QTC_TOKEN']}"})
          @platform_client.http_client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end

        @platform_client
      end

      ##
      # @return [Qtc::Client]
      def client
        if @client.nil?
          @client = Qtc::Client.new(base_url)
          @client.http_client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
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