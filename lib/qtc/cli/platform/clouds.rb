require 'qtc/client'
require_relative '../common'

module Qtc::Cli::Platform
  class Clouds
    include Qtc::Cli::Common

    def list
      accounts = platform_client.get('/user/accounts')
      template = '%-40.40s %-40.40s'
      puts template % ['ID', 'NAME']
      accounts['results'].each do |account|
        name = account['name']
        name = "* #{name}" if account['id'] == inifile['platform']['current_cloud']
        puts template % [account['id'], name]
      end
    end

    def use(id)
      account = platform_client.get("/accounts/#{id}")
      puts "Using cloud: #{account['name']} (#{id})"
      inifile['platform']['current_cloud'] = id
      inifile['platform']['current_dc'] = account['datacenter']['id']
      inifile.save(filename: ini_filename)
    end

    def create(name, opts)
      datacenter = opts.datacenter || 'eu-1'
      data = {name: name, datacenter: datacenter, vpc: opts.vpc}
      platform_client.post('/accounts', data)
    end
  end
end
