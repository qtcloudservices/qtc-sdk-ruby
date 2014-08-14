module Qtc
  module Cli
    class Instances < Thor
      desc 'ls', 'List instances'
      def ls
        accounts = platform_client.get('/user/accounts')
        accounts['results'].each do |account|
          puts "\n=> #{account['name']}: #{account['id']}"
          instances = platform_client.get("/accounts/#{account['id']}/instances")
          instances['results'].each do |instance|
            puts " * #{instance['id']} #{instance['name']}"
          end
        end
      rescue
        abort("Error: can't list instances")
      end

      desc 'show INSTANCE_ID', 'Show instance details'
      def show(id)
        json = platform_client.get("/instances/#{id}")
        puts "=== #{json['id']}"
        puts "Name: \t\t#{json['name']}"
        puts "State: \t\trunning"
        puts "Type: \t\t#{json['serviceProvider']['title']}"
        puts "Datacenter: \t#{json['datacenterId']}"
      rescue
        abort("Error: can't show instance information")
      end

      desc 'create CLOUD_ID TYPE NAME', 'Create a new instance'
      option :datacenter, default: 'eu-1'
      def create(cloud_id, type, name)
        data = {name: name, serviceProviderId: type, datacenterId: options[:datacenter]}
        platform_client.post("/accounts/#{cloud_id}/instances", data)
      rescue
        abort("Error: can't create a new instance")
      end

      private

      def platform_client
        abort('error: QTC_TOKEN environment variable is not set (you can get it from https://console.qtcloudservices.com)') if ENV['QTC_TOKEN'].nil?

        if @platform_client.nil?
          @platform_client = Qtc::Client.new(platform_base_url, {'Authorization' => "Bearer #{ENV['QTC_TOKEN']}"})
        end

        @platform_client
      end

      def platform_base_url
        ENV['QTC_PLATFORM_URL'] || 'https://api.qtc.io/v1'
      end
    end
  end
end