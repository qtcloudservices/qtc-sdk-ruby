require_relative 'base'

module Qtc
  module Cli
    class Eds::Instances < Eds::Base

      def list
        accounts = platform_client.get('/user/accounts')
        accounts['results'].each do |account|
          print color("== #{account['name']}: #{account['id']}", :cyan)
          instances = platform_client.get("/accounts/#{account['id']}/instances", {provider: 'eds'})
          instances['results'].each do |instance|
            say(" ~ <%= color('#{instance['id']}', :green) %> #{instance['name']} <%= color('#{instance['tags'].join(', ')}', :yellow) %>")
          end
          puts ''
        end
      end

      def create(cloud_id, name)
        data = {
            name: name,
            serviceProviderId: 'eds',
            datacenterId: options.datacenter || 'eu-1'
        }
        response = platform_client.post("/accounts/#{cloud_id}/instances", data)
        puts response['id']
      end
    end
  end
end
