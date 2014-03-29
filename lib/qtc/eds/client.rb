require_relative 'collection'

module Qtc
  module Eds
    class Client

      DEFAULT_OPTIONS = {
          api_url: 'https://api.engin.io/v1'
      }

      ##
      # Initialize
      #
      # @param [String] backend_id
      # @param [Hash] options
      def initialize(backend_id, options = {})
        @options = DEFAULT_OPTIONS.merge(options)
        @backend_id = backend_id
        headers = {'Enginio-Backend-Id' => @backend_id}
        @client = Qtc::Client.new(@options[:api_url], headers)
      end


      ##
      # Get collection
      #
      # @param [String] name
      # @return [Qtc::Eds::Collection]
      def collection(name)
        Qtc::Eds::Collection.new(@client, "/objects/#{name}")
      end

      def users
        Qtc::Eds::Collection.new(@client, "/users")
      end

      def usergroups
        Qtc::Eds::Collection.new(@client, "/usergroups")
      end

      ##
      # Set access token
      #
      # @param [String] access_token
      def access_token=(access_token)
        if !token.blank?
          @client.default_headers['Authorization'] = "Bearer #{access_token}"
        else
          @client.default_headers.delete('Authorization')
        end
      end

      ##
      # Call block with given access token
      #
      # @param [String] access_token
      # @param []
      def with_access_token(access_token, &block)
        prev_auth = @client.default_headers['Authorization'].dup
        @client.default_headers['Authorization'] = "Bearer #{access_token}"
        result = call(&block)
        @client.default_headers['Authorization'] = prev_auth
        result
      ensure
        @client.default_headers['Authorization'] = prev_auth if prev_auth
      end

      def create_user_token(username, password)
        body = {
            grant_type: 'password',
            username: username,
            password: password
        }
        @client.post('/auth/oauth2/token', body, {}, {'Content-Type' => 'application/x-www-form-urlencoded'})
      end

      def revoke_user_token(token)
        body = {
            token: token
        }
        @client.post('/auth/oauth2/revoke', body, {}, {'Content-Type' => 'application/x-www-form-urlencoded'})
      end
    end
  end
end