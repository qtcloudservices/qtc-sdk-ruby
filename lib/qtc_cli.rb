require 'thor'
require 'qtc/client'
require 'qtc/cli/mar'

class QtcCli < Thor
  desc 'mar', 'Managed application runtime commands'
  subcommand "mar", Qtc::Cli::Mar
end