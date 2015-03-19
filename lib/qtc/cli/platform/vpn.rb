require 'base64'

module Qtc
  module Cli
    class Platform::Vpn
      include Qtc::Cli::Common

      def create
        self.datacenter_id = vpn_datacenter_id
        client.post('/vpn_containers', {name: 'default vpn'}, {}, {'Authorization' => "Bearer #{current_cloud_token}"})
      end

      def show
        result = client.get('/vpn_containers', {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        vpn = result['results'][0]
        if vpn
          puts "id: #{vpn['id']}"
          puts "name: #{vpn['name']}"
          puts "state: #{vpn['state']}"
        else
          puts 'vpn not found, you can create vpn service with: qtc-cli vpn:create'
        end
      end

      def start
        result = client.get('/vpn_containers', {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        vpn = result['results'][0]
        if vpn
          client.post("/vpn_containers/#{vpn['id']}/start", {}, {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        else
          puts 'vpn not found, you can create vpn service with: qtc-cli vpn:create'
        end
      end

      def stop
        result = client.get('/vpn_containers', {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        vpn = result['results'][0]
        if vpn
          client.post("/vpn_containers/#{vpn['id']}/stop", {}, {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        else
          puts 'vpn not found, you can create vpn service with: qtc-cli mdb vpn:create'
        end
      end

      def destroy
        result = client.get('/vpn_containers', {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        vpn = result['results'][0]
        if vpn
          client.delete("/vpn_containers/#{vpn['id']}", {}, {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        end
      end

      def config
        all = client.get('/vpn_containers', {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        if all['results'][0]
          vpn = all['results'][0]
          if vpn['state'] != 'running'
            puts 'Cannot get config because vpn is not running'
            exit 1
          end

          vpn = client.get("/vpn_containers/#{vpn['id']}", {}, {'Authorization' => "Bearer #{current_cloud_token}"})
          if vpn['vpn_config']
            puts Base64.decode64(vpn['vpn_config'])
          end
        end
      end

      def vpn_datacenter_id
        "mdb-#{current_cloud_dc}"
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
        datacenters = inifile['datacenters'] || {}
        if !self.vpn_datacenter_id.nil? && datacenters.has_key?(self.vpn_datacenter_id)
          "#{datacenters[self.vpn_datacenter_id]}/v1"
        else
          raise ArgumentError.new('Unknown datacenter. Please run qtc-cli datacenters to get latest list of your datacenters')
        end
      end
    end
  end
end
