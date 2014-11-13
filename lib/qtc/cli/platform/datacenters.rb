require 'qtc/client'
require_relative '../common'

module Qtc::Cli::Platform
  class Datacenters
    include Qtc::Cli::Common

    def list
      datacenters = platform_client.get('/datacenters')
      inifile['datacenters'] = {}

      puts datacenters
      datacenters['results'].each do |datacenter|
        datacenter['services'].each do |service|
          inifile['datacenters']["#{service['id']}-#{datacenter['id']}"] = service['url']
        end
        print color("~ #{datacenter['id']} (#{datacenter['description']})", :bold)
      end
      inifile.save(filename: ini_filename)
    end
  end
end
