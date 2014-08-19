program :name, 'qtc-cli'
program :version, '0.1.0'
program :description, 'Command line interface for Qt Cloud Services'

require_relative 'clouds'
command 'clouds' do |c|
  c.syntax = 'qtc-cli clouds'
  c.description = 'List all clouds'
  c.action do |args, options|
    Qtc::Cli::Clouds.new.list
  end
end

require_relative 'eds/commands'
require_relative 'mar/commands'


