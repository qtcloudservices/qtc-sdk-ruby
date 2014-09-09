require 'base64'
require_relative 'base'

module Qtc
  module Cli
    class Mar::SslCertificates < Mar::Base


      def create(options)
        raise ArgumentError.new("--key=#{options.key} is not a file") unless File.exists?(File.expand_path(options.key))
        raise ArgumentError.new("--cert=#{options.cert} is not a file") unless File.exists?(File.expand_path(options.cert))

        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          data = {
            name: instance_id,
            privateKey: File.read(File.expand_path(options.key)),
            certificateBody: File.read(File.expand_path(options.cert))
          }
          client.post("/apps/#{instance_id}/ssl_certificate", data, {}, {'Authorization' => "Bearer #{token}"})
        end
      end

      def destroy(options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          token = instance_data['authorizations'][0]['access_token']
          client.delete("/apps/#{instance_id}/ssl_certificate", {}, {}, {'Authorization' => "Bearer #{token}"})
        end
      end
    end
  end
end
