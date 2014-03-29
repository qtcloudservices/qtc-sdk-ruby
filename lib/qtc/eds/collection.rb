module Qtc
  module Eds
    class Collection

      ##
      # Initialize EDS collection
      #
      # @param [Qtc::Client] client
      # @param [String] path
      def initialize(client, path)
        @client = client
        @path = path
      end

      ##
      # Insert a new object
      #
      # @param [Hash] object
      # @return [Hash]
      def insert(object)
        client.post(path, object)
      end

      ##
      # Update object
      #
      # @param [String] id
      # @param [Hash] object
      # @return [Hash]
      def update(id, object)
        client.put("#{path}/#{id}", object)
      end

      ##
      # Atomic operation
      #
      # @param [String] id
      # @param [Hash] operation
      # @return [Hash]
      def atomic_operation(id, operation)
        client.put("#{path}/#{id}/atomic", operation)
      end

      ##
      # Remove object
      #
      # @param [String]
      # @return [Hash]
      def remove(id)
        client.delete("#{path}/#{id}")
      end

      ##
      # Find object by id
      #
      # @param [String] id
      # @return [Hash]
      def find_one(id)
        client.get("#{path}/#{id}")
      end

      ##
      # Find objects
      #
      # @param [Hash] params
      # @return [Array<Hash>]
      def find(params = {})
        if params[:q] && params[:q].is_a?(Hash)
          params[:q] = params[:q].to_json
        end
        if params[:sort] && !params[:sort].is_a?(String)
          params[:sort] = params[:sort].to_json
        end
        response = client.get("#{path}", params)
        response['results']
      end

      ##
      # Set object permissions
      #
      # @param [String]
      def set_permissions(id, permissions)
        client.post("#{path}/#{id}/access", permissions)
      end

      ##
      # Add permissions
      #
      # @param [String] id
      # @param [Hash] permissions
      # @return [Hash]
      def add_permissions(id, permissions)
        client.put("#{path}/#{id}/access", permissions)
      end

      ##
      # Remove permissions
      #
      # @param [String] id
      # @param [Hash] permissions
      # @return [Hash]
      def remove_permissions(id, permissions)
        client.delete("#{path}/#{id}/access", permissions)
      end

      protected

      ##
      # Get client
      #
      # @return [Qtc::Client]
      def client
        @client
      end

      ##
      # Get path
      #
      # @return [String]
      def path
        @path
      end
    end
  end
end