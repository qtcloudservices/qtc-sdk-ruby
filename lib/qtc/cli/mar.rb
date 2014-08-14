module Qtc
  module Cli
    class Mar < Thor

      desc 'show INSTANCE_ID', 'Show runtime instance information'
      def show(instance_id)
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          result = client.get("/apps/#{instance_id}", nil,  {'Authorization' => "Bearer #{token}"})
          puts "ID: #{result['id']}"
          puts "Type: #{result['type']}"
          puts "Name: #{result['name']}"
          puts "Size: #{result['size']}"
          puts "State: #{result['state']}"
          puts "Structure: #{result['structure']}"
        end
      rescue
        abort("Error: Can't show instance information")
      end

      desc 'scale INSTANCE_ID process=count', 'Scale runtime instance processes'
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

      desc 'env INSTANCE_ID FOO=bar', 'Set runtime instance environment variables'
      def env(instance_id, *vars)
        env_vars = {}
        vars.each do |type|
          arr = type.strip.split("=")
          if arr[0]
            env_vars[arr[0]] = arr[1]
          end
        end
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          if env_vars.keys.size > 0
            client.put("/apps/#{instance_id}/env_vars", env_vars, {}, {'Authorization' => "Bearer #{token}"})
          else
            env_vars = client.get("/apps/#{instance_id}/env_vars", {}, {'Authorization' => "Bearer #{token}"})
            env_vars.each do |key, value|
              puts "#{key}=#{value}"
            end
          end
        end
      rescue
        abort("Error: can't show instance information")
      end

      desc 'logs INSTANCE_ID', 'Show runtime instance logs'
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
      rescue
        abort("Error: can't show logs for this instance")
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