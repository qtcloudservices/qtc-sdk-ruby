require 'qtc/version'

program :name, 'qtc-cli'
program :version, Qtc::VERSION
program :description, 'Command line interface for Qt Cloud Services'

default_command :help
never_trace!

require_relative 'platform/commands'
require_relative 'eds/commands'
require_relative 'mar/commands'
