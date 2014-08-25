require_relative 'instances'

command 'eds instances' do |c|
  c.syntax = 'qtc-cli eds instances'
  c.description = 'List all EDS instances'
  c.action do |args, options|
    Qtc::Cli::Eds::Instances.new.list
  end
end

command 'eds instances:launch' do |c|
  c.syntax = 'qtc-cli eds instances:launch CLOUD_ID NAME'
  c.description = 'Launch a new EDS instance'
  c.action do |args, options|
    raise ArgumentError.new('CLOUD_ID is required') if args[0].nil?
    raise ArgumentError.new('NAME is required') if args[1].nil?
    Qtc::Cli::Eds::Instances.new.create(args[0], args[1])
  end
end