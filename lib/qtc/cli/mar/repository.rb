require_relative 'base'

module Qtc
  module Cli
    class Mar::Repository < Mar::Base

      def purge_cache(options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          client.delete("/apps/#{instance_id}/build_cache", nil, {}, {'Authorization' => "Bearer #{token}"})
        end
      end

      def reset(options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          client.delete("/apps/#{instance_id}/repository", nil, {}, {'Authorization' => "Bearer #{token}"})
        end
      end
    end
  end
end
