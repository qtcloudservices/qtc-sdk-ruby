require_relative 'base'

module Qtc
  module Cli
    class Mar::Env < Mar::Base

      def set(vars, options)
        instance_id = resolve_instance_id(options)
        env_vars = {}
        vars.each do |type|
          arr = type.strip.split('=', 2)
          if arr[0]
            if arr[1].nil? || arr[1] == ''
              env_vars[arr[0]] = nil
            else
              env_vars[arr[0]] = arr[1]
            end
          end
        end
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          client.put("/apps/#{instance_id}/env_vars", env_vars, {}, {'Authorization' => "Bearer #{token}"})
        end
      end

      def show(options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          env_vars = client.get("/apps/#{instance_id}/env_vars", {}, {'Authorization' => "Bearer #{token}"})
          env_vars.each do |key, value|
            puts "#{key}=#{value}"
          end
        end
      end
    end
  end
end
