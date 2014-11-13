require_relative 'base'

module Qtc
  module Cli
    class Mar::Apps < Mar::Base

      def list
        accounts = platform_client.get('/user/accounts')
        accounts['results'].each do |account|
          instances = platform_client.get("/accounts/#{account['id']}/instances", {provider: 'mar'})
          if instances['results'].size > 0
            print color("== #{account['name']} (#{account['datacenter']['id']}): #{account['id']}")
            instances['results'].each do |instance|
              say(" ~ <%= color('#{instance['id']}', :green) %> #{instance['name']} <%= color('#{instance['tags'].join(', ')}', :yellow) %>")
            end
            puts ''
          end
        end
      end

      def show(options)
        instance_id = resolve_instance_id(options)

        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          result = client.get("/apps/#{instance_id}", nil,  {'Authorization' => "Bearer #{token}"})
          puts "Id: #{result['id']}"
          puts "Name: #{result['name']}"
          puts "Size: #{size_mapping[result['size'].to_s] || result['size']}"
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

      def restart(options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          client.post("/apps/#{instance_id}/restart", {}, nil, {'Authorization' => "Bearer #{token}"})
        end

      end

      def logs(options)
        offset = options.offset || 0
        limit = options.limit || 100
        stream = options.stream || nil

        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          result = client.get("/apps/#{instance_id}/logs", {offset: offset, limit: limit}, {'Authorization' => "Bearer #{token}"})
          result['results'].each do |r|
            line = ''
            line << "[#{r['time']}] " if options.timestamp == true
            line << r['log']
            puts line
          end
        end
      end

      def scale(args, options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          app = client.get("/apps/#{instance_id}", nil,  {'Authorization' => "Bearer #{token}"})
          structure = app['structure']
          scale = {}
          args.each do |type|
            arr = type.strip.split("=")
            if arr[0] && arr[1]
              raise ArgumentError.new("#{arr[0]} is not defined in Procfile") unless structure.has_key?(arr[0])
              scale[arr[0]] = arr[1]
            end
          end
          client.post("/apps/#{instance_id}/scale", scale, {}, {'Authorization' => "Bearer #{token}"})
        end
      end

      def size_mapping
        {
            '1' => 'mini',
            '2' => 'small',
            '4' => 'medium',
            '8' => 'large'
        }
      end
    end
  end
end
