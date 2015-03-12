require_relative 'base'

module Qtc
  module Cli
    class Mdb::Instances < Mdb::Base
      include Qtc::Cli::Common

      def list
        instances = platform_client(current_cloud_token).get("/accounts/#{current_cloud_id}/instances", {provider: 'mdb'})
        template = "%-20.20s %-30.30s %-20.20s"
        puts template % ["ID", "NAME", "TAGS"]
        instances['results'].each do |instance|
          puts template % [instance['id'], instance['name'], instance['tags'].join(',')]
        end
      end

      def show(options)
        raise ArgumentError.new('--id is required') if options.id.nil?

        self.datacenter_id = self.resolve_datacenter_id(options.id)
        instance_id = options.id
        instance_data = instance_info(instance_id)
        if instance_data
          result = client.get("/services/#{instance_id}", nil,  {'Authorization' => "Bearer #{current_cloud_token}"})
          puts "Id: #{result['id']}"
          puts "Name: #{result['name']}"
          puts "Type: #{result['image']['name']}"
          puts "Size: #{result['size'].to_i * 256}MB"
          puts "State: #{result['state']}"
        end
      end

      def create(name, options)
        sizes = {'256m' => 1, '512m' => 2, '768m' => 3, '1024m' => 4}
        size = sizes[options.size.to_s.to_sym] || 1
        data = {
            name: name,
            serviceProviderId: 'mdb',
            config: {
                runtimeSize: size,
                serviceImage: "qtcs/#{options.type}"
            }
        }
        response = platform_client.post("/accounts/#{current_cloud_id}/instances", data)
        puts response['id']
      end

      def logs(options)
        raise ArgumentError.new('--id is required') if options.id.nil?

        self.datacenter_id = self.resolve_datacenter_id(options.id)
        offset = options.offset || 0
        limit = options.limit || 100
        stream = options.stream || nil

        instance_id = options.id
        instance_data = instance_info(instance_id)
        if instance_data
          result = client.get("/services/#{instance_id}/logs", {offset: offset, limit: limit},  {'Authorization' => "Bearer #{current_cloud_token}"})
          result['results'].each do |r|
            line = ''
            line << "[#{r['time']}] " if options.timestamp == true
            line << r['log']
            puts line
          end
        end
      end

    end
  end
end
