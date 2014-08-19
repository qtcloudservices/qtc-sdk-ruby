require_relative 'base'

module Qtc
  module Cli
    class Mar::Apps < Mar::Base

      def list
        accounts = platform_client.get('/user/accounts')
        accounts['results'].each do |account|
          print color("=> #{account['name']}: #{account['id']}", :bold)
          instances = platform_client.get("/accounts/#{account['id']}/instances", {provider: 'mar'})
          instances['results'].each do |instance|
            print color(" * #{instance['id']} #{instance['name']}", :gray) if instance['config']['MAR_GIT_ADDRESS']
          end
          puts ''
        end
      end

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
          puts "Structure: #{JSON.pretty_generate(result['structure'])}"
          status = client.get("/apps/#{instance_id}/status", nil,  {'Authorization' => "Bearer #{token}"})
          puts "Processes: #{JSON.pretty_generate(status['processes'])}"
        end
      end

      def create(cloud_id, name, options)
        sizes = {mini: 1, small: 2, medium: 4}
        size = sizes[options.size.to_s.to_sym] || 1
        data = {
            name: name,
            serviceProviderId: 'mar',
            datacenterId: options.datacenter || 'eu-1',
            config: {
                runtimeSize: size,
                runtimeType: 'app'
            }
        }
        response = platform_client.post("/accounts/#{cloud_id}/instances", data)
        puts response['id']
      end

      def restart(instance_id)
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          client.post("/apps/#{instance_id}/restart", {}, nil, {'Authorization' => "Bearer #{token}"})
        end

      end

      def logs(instance_id, options)
        offset = options.offset || 0
        limit = options.limit || 100

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
      end

      private

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
    end
  end
end