require 'thor'
require 'qtc/client'
require 'qtc/cli/instances'
require 'qtc/cli/mar'

class QtcCli < Thor
  desc 'mar', 'Managed application runtime commands'
  subcommand 'mar', Qtc::Cli::Mar

  desc 'instances', 'Instances commands'
  subcommand 'instances', Qtc::Cli::Instances
end