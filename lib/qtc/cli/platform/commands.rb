module Qtc::Cli::Platform; end;

require_relative 'datacenters'
require_relative 'clouds'
require_relative 'vpn'
require_relative 'user'
require_relative 'ssh_keys'

command 'datacenters' do |c|
  c.syntax = 'qtc-cli datacenters'
  c.description = 'List all datacenters'
  c.action do |args, options|
    Qtc::Cli::Platform::Datacenters.new.list
  end
end

command 'clouds:list' do |c|
  c.syntax = 'qtc-cli clouds:list'
  c.description = 'List all clouds'
  c.action do |args, options|
    Qtc::Cli::Platform::Clouds.new.list
  end
end

command 'clouds:use' do |c|
  c.syntax = 'qtc-cli clouds:use <id>'
  c.description = 'Set default cloud to use'
  c.action do |args, options|
    Qtc::Cli::Platform::Clouds.new.use(args[0])
  end
end

command 'vpn:create' do |c|
  c.syntax = 'qtc-cli vpn:create'
  c.description = 'Create vpn connection'
  c.action do |args, options|
    Qtc::Cli::Platform::Vpn.new.create
  end
end

command 'vpn:show' do |c|
  c.syntax = 'qtc-cli vpn:show'
  c.description = 'Show vpn connection'
  c.action do |args, options|
    Qtc::Cli::Platform::Vpn.new.show
  end
end

command 'vpn:start' do |c|
  c.syntax = 'qtc-cli vpn:start'
  c.description = 'Start vpn server'
  c.action do |args, options|
    Qtc::Cli::Platform::Vpn.new.start
  end
end

command 'vpn:stop' do |c|
  c.syntax = 'qtc-cli vpn:stop'
  c.description = 'Stop vpn server'
  c.action do |args, options|
    Qtc::Cli::Platform::Vpn.new.stop
  end
end

command 'vpn:remove' do |c|
  c.syntax = 'qtc-cli vpn:remove'
  c.description = 'Remove vpn connection'
  c.action do |args, options|
    Qtc::Cli::Platform::Vpn.new.destroy
  end
end

command 'vpn:config' do |c|
  c.syntax = 'qtc-cli vpn:config'
  c.description = 'Show vpn configuration'
  c.action do |args, options|
    Qtc::Cli::Platform::Vpn.new.config
  end
end

command 'clouds:create' do |c|
  c.syntax = 'qtc-cli clouds:create name'
  c.description = 'Create a new cloud'
  c.option '--datacenter STRING', String, 'Specify datacenter for this cloud (default: eu-1)'
  c.option '--vpc', 'Enable virtual private cloud'
  c.action do |args, options|
    Qtc::Cli::Platform::Clouds.new.create(args.join(' '), options)
  end
end

command 'login' do |c|
  c.syntax = 'qtc-cli login'
  c.description = 'Login to Qt Cloud Services'
  c.option '--token STRING', String, 'Personal access token'
  c.action do |args, options|
    Qtc::Cli::Platform::User.new.login(options)
  end
end

command 'logout' do |c|
  c.syntax = 'qtc-cli logout'
  c.description = 'Logout from Qt Cloud Services'
  c.action do |args, options|
    Qtc::Cli::Platform::User.new.logout
  end
end

command 'ssh-keys' do |c|
  c.syntax = 'qtc-cli ssh-keys'
  c.description = 'List ssh keys'
  c.action do |args, options|
    Qtc::Cli::Platform::SshKeys.new.list
  end
end

command 'ssh-keys:add' do |c|
  c.syntax = 'qtc-cli ssh-keys:add'
  c.description = 'Add ssh key'
  c.option '--name NAME', String, 'SSH key name'
  c.option '--key KEY', String, 'Path to SSH public key file'
  c.action do |args, options|
    Qtc::Cli::Platform::SshKeys.new.create(options)
  end
end

command 'ssh-keys:remove' do |c|
  c.syntax = 'qtc-cli ssh-keys:remove'
  c.description = 'Add ssh key'
  c.option '--name NAME', String, 'SSH key name'
  c.action do |args, options|
    Qtc::Cli::Platform::SshKeys.new.destroy(options)
  end
end
