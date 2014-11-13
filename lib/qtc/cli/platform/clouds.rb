require 'qtc/client'
require_relative '../common'

module Qtc::Cli::Platform
  class Clouds
    include Qtc::Cli::Common

    def list
      accounts = platform_client.get('/user/accounts')
      accounts['results'].each do |account|
        print color("~ #{account['name']} (#{account['id']})", :bold)
      end
    end
  end
end
