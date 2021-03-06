require 'base64'
require_relative 'base'

module Qtc
  module Cli
    class Mar::SslCertificates < Mar::Base


      def create(options)
        raise ArgumentError.new("--key=#{options.key} is not a file") unless File.exists?(File.expand_path(options.key))
        raise ArgumentError.new("--cert=#{options.cert} is not a file") unless File.exists?(File.expand_path(options.cert))
        unless options.chain.nil?
          raise ArgumentError.new("--chain=#{options.chain} is not a file") unless File.exists?(File.expand_path(options.chain))
        end

        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          data = {
            name: instance_id,
            privateKey: File.read(File.expand_path(options.key)),
            certificateBody: File.read(File.expand_path(options.cert))
          }
          unless options.chain.nil?
            data[:certificateChain] = File.read(File.expand_path(options.chain))
          end
          client.post("/apps/#{instance_id}/ssl_certificate", data, {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        end
      end

      def destroy(options)
        instance_id = resolve_instance_id(options)
        instance_data = instance_info(instance_id)
        if instance_data
          client.delete("/apps/#{instance_id}/ssl_certificate", {}, {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        end
      end
    end
  end
end
