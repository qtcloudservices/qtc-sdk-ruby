require 'qtc/version'

program :name, 'qtc-cli'
program :version, Qtc::VERSION
program :description, 'Command line interface for Qt Cloud Services'

default_command :help
never_trace!

require_relative 'clouds'
command 'clouds' do |c|
  c.syntax = 'qtc-cli clouds'
  c.description = 'List all clouds'
  c.action do |args, options|
    Qtc::Cli::Clouds.new.list
  end
end

command 'login' do |c|
  c.syntax = 'qtc-cli login'
  c.description = 'Login to Qt Cloud Services'
  c.action do |args, options|
    Qtc::Cli::Clouds.new.login
  end
end

command 'logout' do |c|
  c.syntax = 'qtc-cli logout'
  c.description = 'Logout from Qt Cloud Services'
  c.action do |args, options|
    Qtc::Cli::Clouds.new.logout
  end
end

require_relative 'eds/commands'
require_relative 'mar/commands'
