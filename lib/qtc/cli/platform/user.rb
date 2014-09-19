require 'qtc/client'
require_relative '../common'

module Qtc::Cli::Platform
  class User
    include Qtc::Cli::Common

    def login
      pass = password("Personal Access Token (copy from https://console.qtcloudservices.com/#/user/profile):")
      inifile['platform']['token'] = pass

      response = platform_client(pass).get('/user/accounts', {}) rescue nil
      if response
        inifile.save(filename: ini_filename)
      else
        print color('Invalid Personal Access Token', :red)
      end
    end

    def logout
      inifile['platform'].delete('token')
      inifile.save(filename: ini_filename)
    end
  end
end
