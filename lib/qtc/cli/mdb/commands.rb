require_relative 'instances'

command 'mdb list' do |c|
  c.syntax = 'qtc-cli mdb list'
  c.description = 'List all MDB instances'
  c.action do |args, options|
    Qtc::Cli::Mdb::Instances.new.list
  end
end

command 'mdb show' do |c|
  c.syntax = 'qtc-cli mdb show'
  c.description = 'Show MDB instance info'
  c.option '--id ID', String, 'MDB instance id'
  c.action do |args, options|
    Qtc::Cli::Mdb::Instances.new.show(options)
  end
end

command 'mdb create' do |c|
  c.syntax = 'qtc-cli mdb create NAME'
  c.description = 'Create a new MDB instance'
  c.option '--type TYPE', String, 'MDB type'
  c.option '--size SIZE', String, 'MDB size'
  c.action do |args, options|
    raise ArgumentError.new('NAME is required') if args[0].nil?
    raise ArgumentError.new('--type is required (example: mysql:5.6)') if options.type.nil?
    Qtc::Cli::Mdb::Instances.new.create(args[0], options)
  end
end

command 'mdb logs' do |c|
  c.syntax = 'qtc-cli mdb logs'
  c.description = 'Show MDB logs'
  c.option '--id ID', String, 'MDB instance id'
  c.option '--timestamp', String, 'Include timestamp'
  c.option '--stream', String, 'stdout or stderr'
  c.option '--limit LIMIT', Integer, 'Limit'
  c.option '--offset OFFSET', Integer, 'Offset'
  c.action do |args, options|
    Qtc::Cli::Mdb::Instances.new.logs(options)
  end
end

command 'mdb stop' do |c|
  c.syntax = 'qtc-cli mdb stop'
  c.description = 'Stop MDB instance'
  c.option '--id ID', String, 'MDB instance id'
  c.action do |args, options|
    Qtc::Cli::Mdb::Instances.new.stop(options)
  end
end

command 'mdb start' do |c|
  c.syntax = 'qtc-cli mdb start'
  c.description = 'Start MDB instance'
  c.option '--id ID', String, 'MDB instance id'
  c.action do |args, options|
    Qtc::Cli::Mdb::Instances.new.start(options)
  end
end
