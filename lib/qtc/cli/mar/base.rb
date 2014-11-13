require 'qtc/client'
require_relative '../common'

module Qtc
  module Cli
    module Mar
      class Base
        include Cli::Common

        protected

        def resolve_instance_id(options)
          if options.app.nil?
            instance_id = extract_app_in_dir(options.remote)
          else
            instance_id = options.app
          end
          if instance_id.nil?
            raise ArgumentError.new('Cannot resolve current app, please use --app APP')
          end

          self.datacenter_id = resolve_datacenter_id(instance_id)

          instance_id
        end

        ##
        # @param [String] instance_id
        # @return [String,NilClass]
        def resolve_datacenter_id(instance_id)
          match = instance_id.to_s.match(/^(mar-\w+-\w+)-\w+/)
          if match[1]
            match[1]
          end
        end

        ##
        # @return [Qtc::Client]
        def client
          if @client.nil?
            @client = Qtc::Client.new(base_url)
          end

          @client
        end

        private

        def base_url
          datacenters = inifile['datacenters'] || {}
          if !self.datacenter_id.nil? && datacenters.has_key?(self.datacenter_id)
            "#{datacenters[self.datacenter_id]}/v1"
          else
            raise ArgumentError.new('Unknown datacenter. Please run qtc-cli datacenters to get latest list of your datacenters')
          end
        end
      end
    end
  end
end
