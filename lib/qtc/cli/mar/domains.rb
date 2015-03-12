require_relative 'base'

module Qtc
  module Cli
    class Mar::Domains < Mar::Base

      def list(options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          result = client.get("/apps/#{instance_id}/domains", nil, {'Authorization' => "Bearer #{current_cloud_token}"})
          result['results'].each do |r|
            print color("* #{r['name']}", :bold)
          end
        end
      end

      def create(name, options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          client.post("/apps/#{instance_id}/domains", {name: name}, {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        end
      end

      def destroy(name, options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          client.delete("/apps/#{instance_id}/domains/#{name}", nil, {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        end
      end
    end
  end
end
