require 'qtc/client'
require_relative '../common'

module Qtc
  module Cli
    module Mar
      class Base
        include Cli::Common

        protected

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