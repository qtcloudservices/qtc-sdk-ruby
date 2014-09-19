module Qtc::Cli::Platform; end;

require_relative 'clouds'
require_relative 'user'
require_relative 'ssh_keys'

command 'clouds' do |c|
  c.syntax = 'qtc-cli clouds'
  c.description = 'List all clouds'
  c.action do |args, options|
    Qtc::Cli::Platform::Clouds.new.list
  end
end

command 'login' do |c|
  c.syntax = 'qtc-cli login'
  c.description = 'Login to Qt Cloud Services'
  c.action do |args, options|
    Qtc::Cli::Platform::User.new.login
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
