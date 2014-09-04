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

          instance_id
        end

        ##
        # @return [Qtc::Client]
        def client
          if @client.nil?
            @client = Qtc::Client.new(base_url)
          end

          @client
        end

        def base_url
          ENV['QTC_MAR_URL'] || 'https://mar-eu-1.qtc.io/v1'
        end
      end
    end
  end
end
