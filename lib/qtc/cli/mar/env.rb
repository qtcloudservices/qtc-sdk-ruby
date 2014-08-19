require_relative 'base'

module Qtc
  module Cli
    class Mar::Env < Mar::Base

      def set(instance_id, *vars)
        env_vars = {}
        vars.each do |type|
          arr = type.strip.split("=")
          if arr[0]
            env_vars[arr[0]] = arr[1]
          end
        end
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          client.put("/apps/#{instance_id}/env_vars", env_vars, {}, {'Authorization' => "Bearer #{token}"})
        end
      end

      def show(instance_id)
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