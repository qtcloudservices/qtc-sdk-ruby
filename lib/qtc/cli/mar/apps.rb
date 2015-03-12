require_relative 'base'

module Qtc
  module Cli
    class Mar::Apps < Mar::Base

      def list
        instances = platform_client(current_cloud_token).get("/accounts/#{current_cloud_id}/instances", {provider: 'mar'})
        if instances['results'].size > 0
          template = "%-20.20s %-30.30s %-20.20s"
          puts template % ["ID", "NAME", "TAGS"]
          instances['results'].each do |instance|
            puts template % [instance['id'], instance['name'], instance['tags'].join(',')]
          end
        end
      end

      def show(options)
        instance_id = resolve_instance_id(options)

        instance_data = instance_info(instance_id)
        if instance_data
          result = client.get("/apps/#{instance_id}", nil,  {'Authorization' => "Bearer #{current_cloud_token}"})
          puts "Id: #{result['id']}"
          puts "Name: #{result['name']}"
          puts "Size: #{size_mapping[result['size'].to_s] || result['size']}"
          puts "State: #{result['state']}"
          puts "Structure: #{JSON.pretty_generate(result['structure'])}"
          status = client.get("/apps/#{instance_id}/status", nil,  {'Authorization' => "Bearer #{current_cloud_token}"})
          puts "Processes: #{JSON.pretty_generate(status['processes'])}"
        end
      end

      def create(name, options)
        sizes = {mini: 1, small: 2, medium: 4}
        size = sizes[options.size.to_s.to_sym] || 1
        data = {
            name: name,
            serviceProviderId: 'mar',
            config: {
                runtimeSize: size,
                runtimeType: 'app'
            }
        }
        response = platform_client.post("/accounts/#{current_cloud_id}/instances", data)
        puts response['id']
      end

      def restart(options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          client.post("/apps/#{instance_id}/restart", {}, nil, {'Authorization' => "Bearer #{current_cloud_token}"})
        end

      end

      def logs(options)
        offset = options.offset || 0
        limit = options.limit || 100
        stream = options.stream || nil

        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          result = client.get("/apps/#{instance_id}/logs", {offset: offset, limit: limit}, {'Authorization' => "Bearer #{current_cloud_token}"})
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
          app = client.get("/apps/#{instance_id}", nil,  {'Authorization' => "Bearer #{current_cloud_token}"})
          structure = app['structure']
          scale = {}
          args.each do |type|
            arr = type.strip.split("=")
            if arr[0] && arr[1]
              raise ArgumentError.new("#{arr[0]} is not defined in Procfile") unless structure.has_key?(arr[0])
              scale[arr[0]] = arr[1]
            end
          end
          client.post("/apps/#{instance_id}/scale", scale, {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        end
      end

      def exec(command, options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          data = {
              cmd: command,
              processId: options.process
          }
          result = client.post("/apps/#{instance_id}/exec", data, {}, {'Authorization' => "Bearer #{current_cloud_token}"})
          puts result['stderr']
          puts result['stdout']
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
