require_relative 'base'

module Qtc
  module Cli
    class Mar::Repository < Mar::Base

      def purge_cache(options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          client.delete("/apps/#{instance_id}/build_cache", nil, {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        end
      end

      def reset(options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          client.delete("/apps/#{instance_id}/repository", nil, {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        end
      end
    end
  end
end
