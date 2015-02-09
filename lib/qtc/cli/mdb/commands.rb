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
