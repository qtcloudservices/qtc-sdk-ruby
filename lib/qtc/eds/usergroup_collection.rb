module Qtc
  module Eds
    class UsergroupCollection < Collection

      ##
      # Initialize EDS usergroup collection
      #
      # @param [Qtc::Client] client
      def initialize(client)
        super(client, '/usergroups')
      end

      ##
      # Add member to usergroup
      #
      # @param [String] id
      # @param [Hash] user
      def add_member(id, user)
        client.post("#{path}/#{id}/members", user)
      end

      ##
      # Remove member from usergroup
      #
      # @param [String] id
      # @param [Hash] user
      def remove_member(id, user)
        client.delete("#{path}/#{id}/members", user)
      end

      ##
      # Get usergroup members
      #
      # @param [String] id
      # @return [Array<Hash>]
      def members(id)
        response = client.get("#{path}/#{id}/members")
        response['results']
      end
    end
  end
end