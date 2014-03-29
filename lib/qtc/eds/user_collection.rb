module Qtc
  module Eds
    class UserCollection < Collection

      ##
      # Initialize EDS user collection
      #
      # @param [Qtc::Client] client
      def initialize(client)
        super(client, '/users')
      end
    end
  end
end