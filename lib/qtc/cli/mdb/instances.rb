require_relative 'base'

module Qtc
  module Cli
    class Mdb::Instances < Mdb::Base
      include Qtc::Cli::Common

      def list
        accounts = platform_client.get('/user/accounts')
        accounts['results'].each do |account|
          print color("== #{account['name']}: #{account['id']}")
          instances = platform_client.get("/accounts/#{account['id']}/instances", {provider: 'mdb'})
          instances['results'].each do |instance|
            say(" ~ <%= color('#{instance['id']}', :green) %> #{instance['name']} <%= color('#{instance['tags'].join(', ')}', :yellow) %>")
          end
          puts ''
        end
      end

      def show(options)
        raise ArgumentError.new('--id is required') if options.id.nil?

        self.datacenter_id = self.resolve_datacenter_id(options.id)
        instance_id = options.id
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          result = client.get("/services/#{instance_id}", nil,  {'Authorization' => "Bearer #{token}"})
          puts "Id: #{result['id']}"
          puts "Name: #{result['name']}"
          puts "Type: #{result['image']['name']}"
          puts "Size: #{result['size'].to_i * 256}MB"
          puts "State: #{result['state']}"
        end
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
          token = instance_data['authorizations'][0]['access_token']
          result = client.get("/services/#{instance_id}/logs", {offset: offset, limit: limit},  {'Authorization' => "Bearer #{token}"})
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
