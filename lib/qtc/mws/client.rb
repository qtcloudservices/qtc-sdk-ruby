require 'faye/websocket'

module Qtc
  module Mws
    class Client

      DEFAULT_OPTIONS = {
          api_url: 'https://mws-eu-1.qtc.io/v1'
      }

      attr_accessor :gateway_id, :options, :http_client

      ##
      # Initialize
      #
      # @param [String] gateway_id
      # @param [Hash] options
      def initialize(gateway_id, options = {})
        self.gateway_id = opts[:gateway_id]
        self.options = DEFAULT_OPTIONS.merge(options)
        self.http_client = Qtc::Client.new(http_client_url)
      end

      ##
      # Send message to websocket clients
      #
      # @param [String] message
      # @param [Hash] receivers
      # @option receivers [Array<String>] :sockets
      # @option receivers [Array<String>] :tags
      def send_message(message, receivers = {sockets: ['*'], tags: nil})
        data = {data: message, receivers: receivers}
        self.http_client.post('/messages', data)
      end

      ##
      # Get websocket client
      #
      # @return [Faye::WebSocket::Client]
      def websocket_client
        uri = self.http_client.get('/websocket_uri')
        Faye::WebSocket::Client.new(uri["uri"])
      end

      private

      ##
      # Get url for HTTPClient
      #
      # @return [String]
      def http_client_url
        "#{self.options[:api_url]}/gateways/#{self.gateway_id}"
      end
    end
  end
end
