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
        self.gateway_id = gateway_id
        self.options = DEFAULT_OPTIONS.merge(options)
        self.http_client = Qtc::Client.new(http_client_url)
        self.access_token = options[:access_token]
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
      # Create a new websocket object
      #
      # @param [Array<String>] tags
      # @return [Hash]
      def create_socket(tags = [])
        data = {tags: tags}
        self.http_client.post('/sockets', data)
      end

      ##
      # Get websocket uri
      #
      # @return [Hash]
      def websocket_uri
        self.http_client.get('/websocket_uri')
      end

      ##
      # Get websocket client
      #
      # @param [String] uri
      # @return [Faye::WebSocket::Client]
      def websocket_client(uri = nil)
        uri = websocket_uri["uri"] if uri.nil?

        Faye::WebSocket::Client.new(uri)
      end

      ##
      # Set access token
      #
      # @param [String] access_token
      def access_token=(access_token)
        if !access_token.nil?
          self.http_client.default_headers['Authorization'] = "Bearer #{access_token}"
        else
          self.http_client.default_headers.delete('Authorization')
        end
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