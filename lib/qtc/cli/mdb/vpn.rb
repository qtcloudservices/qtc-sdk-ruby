require_relative 'base'
require "base64"

module Qtc
  module Cli
    class Mdb::Vpn < Mdb::Base
      include Qtc::Cli::Common

      def create(options)
        self.datacenter_id = mdb_datacenter_id
        result = client.post("/vpn_containers", {name: 'default vpn'}, {}, {'Authorization' => "Bearer #{current_cloud_token}"})
      end

      def show(options)
        self.datacenter_id = mdb_datacenter_id

        result = client.get("/vpn_containers", {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        vpn = result['results'][0]
        if vpn
          puts "name: #{vpn['name']}"
          puts "state: #{vpn['state']}"
        else
          puts "vpn not found, you can create vpn service with: qtc-cli mdb vpn:create"
        end
      end

      def destroy
        self.datacenter_id = mdb_datacenter_id

        client.delete("/vpn_containers", {}, {}, {'Authorization' => "Bearer #{current_cloud_token}"})
      end

      def config(options)
        self.datacenter_id = mdb_datacenter_id
        all = client.get("/vpn_containers", {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        if all['results'][0]
          vpn = all['results'][0]
          vpn = client.get("/vpn_containers/#{vpn['id']}", {}, {'Authorization' => "Bearer #{current_cloud_token}"})
          if vpn['vpn_config']
            puts Base64.decode64(vpn['vpn_config'])
          end
        end
      end
    end
  end
end
