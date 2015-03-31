require 'qtc/client'
require_relative '../common'

module Qtc::Cli::Platform
  class Datacenters
    include Qtc::Cli::Common

    def list
      datacenters = platform_client.get('/datacenters')
      inifile['datacenters'] = {}

      template = '%-20.20s %-40.40s'
      puts template % ['NAME', 'DESCRIPTION']
      datacenters['results'].each do |datacenter|
        datacenter['services'].each do |service|
          inifile['datacenters']["#{service['id']}-#{datacenter['id']}"] = service['url']
        end
        puts template % [datacenter['id'], datacenter['description']]
      end
      inifile.save(filename: ini_filename)
    end
  end
end
