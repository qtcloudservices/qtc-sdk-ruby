require 'qtc/client'
require_relative 'common'

module Qtc
  module Cli
    class Clouds
      include Common

      def list
        accounts = platform_client.get('/user/accounts')
        accounts['results'].each do |account|
          print color("* #{account['id']}: #{account['name']}", :bold)
        end
      end
    end
  end
end