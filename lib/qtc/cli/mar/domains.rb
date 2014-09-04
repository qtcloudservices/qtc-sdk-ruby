require_relative 'base'

module Qtc
  module Cli
    class Mar::Domains < Mar::Base

      def list(options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          result = client.get("/apps/#{instance_id}/domains", nil, {'Authorization' => "Bearer #{token}"})
          result['results'].each do |r|
            print color("* #{r['name']}", :bold)
          end
        end
      end

      def create(name, options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          client.post("/apps/#{instance_id}/domains", {name: name}, {}, {'Authorization' => "Bearer #{token}"})
        end
      end

      def destroy(name, options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          client.delete("/apps/#{instance_id}/domains/#{name}", nil, nil, {'Authorization' => "Bearer #{token}"})
        end
      end
    end
  end
end
