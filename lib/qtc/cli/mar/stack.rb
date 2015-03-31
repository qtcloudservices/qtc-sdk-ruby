require_relative 'base'

module Qtc
  module Cli
    class Mar::Stack < Mar::Base

      def update(name, options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          client.put("/apps/#{instance_id}", {stack: name}, nil, {'Authorization' => "Bearer #{current_cloud_token}"})
          puts "Stack is now set to: #{name}"
          puts "Next release on #{instance_data['name']} will use #{name} stack."
          puts "Use `git push <remote> master` to create new release on #{name}"
        end
      end

      def show(options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          env_vars = client.get("/apps/#{instance_id}/env_vars", {}, {'Authorization' => "Bearer #{current_cloud_token}"})
          puts "App is using stack: #{env_vars['STACK']}"
          puts ""
        end
      end
    end
  end
end
