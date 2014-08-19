require_relative 'apps'
require_relative 'domains'
require_relative 'env'

command 'mar:apps' do |c|
  c.syntax = 'qtc-cli mar:apps'
  c.description = 'List all apps'
  c.action do |args, options|
    Qtc::Cli::Mar::Apps.new.list
  end
end

command 'mar:app show' do |c|
  c.syntax = 'qtc-cli mar:app show INSTANCE_ID'
  c.description = 'Show app details'
  c.action do |args, options|
    raise ArgumentError.new('INSTANCE_ID is required') if args[0].nil?
    Qtc::Cli::Mar::Apps.new.show(args[0])
  end
end

command 'mar:app restart' do |c|
  c.syntax = 'qtc-cli mar:app restart INSTANCE_ID'
  c.description = 'Restart app'
  c.action do |args, options|
    raise ArgumentError.new('INSTANCE_ID is required') if args[0].nil?
    Qtc::Cli::Mar::Apps.new.restart(args[0])
  end
end

command 'mar:app launch' do |c|
  c.syntax = 'qtc-cli mar:app create CLOUD_ID NAME'
  c.description = 'Launch a new app instance'
  c.option '--size SIZE', String, 'App runtime size'
  c.option '--datacenter DATACENTER', String, 'Datacenter id'
  c.action do |args, options|
    raise ArgumentError.new('CLOUD_ID is required') if args[0].nil?
    raise ArgumentError.new('NAME is required') if args[1].nil?
    Qtc::Cli::Mar::Apps.new.create(args[0], args[1], options)
  end
end

command 'mar:app:domains' do |c|
  c.syntax = 'qtc-cli mar:app:domains INSTANCE_ID'
  c.description = 'Show app domains'
  c.action do |args, options|
    raise ArgumentError.new('INSTANCE_ID is required') if args[0].nil?
    Qtc::Cli::Mar::Domains.new.list(args[0])
  end
end

command 'mar:app:domains add' do |c|
  c.syntax = 'qtc-cli mar:app:domains add INSTANCE_ID DOMAIN'
  c.description = 'Add custom domain to app'
  c.action do |args, options|
    raise ArgumentError.new('INSTANCE_ID is required') if args[0].nil?
    raise ArgumentError.new('DOMAIN is required') if args[1].nil?
    Qtc::Cli::Mar::Domains.new.create(args[0], args[1])
  end
end

command 'mar:app:domains remove' do |c|
  c.syntax = 'qtc-cli mar:app:domains remove INSTANCE_ID DOMAIN'
  c.description = 'Remove custom domain from app'
  c.action do |args, options|
    raise ArgumentError.new('INSTANCE_ID is required') if args[0].nil?
    raise ArgumentError.new('DOMAIN is required') if args[1].nil?
    Qtc::Cli::Mar::Domains.new.destroy(args[0], args[1])
  end
end

command 'mar:app:logs' do |c|
  c.syntax = 'qtc-cli mar:app:logs INSTANCE_ID'
  c.description = 'Show log entries'
  c.option '--limit LIMIT', Integer, 'Limit'
  c.option '--offset OFFSET', Integer, 'Offset'
  c.action do |args, options|
    raise ArgumentError.new('INSTANCE_ID is required') if args[0].nil?
    Qtc::Cli::Mar::Apps.new.logs(args[0], options)
  end
end

command 'mar:app:env' do |c|
  c.syntax = 'qtc-cli mar:app:env INSTANCE_ID'
  c.description = 'Show environment variables'
  c.action do |args, options|
    raise ArgumentError.new('INSTANCE_ID is required') if args[0].nil?
    Qtc::Cli::Mar::Env.new.show(args[0])
  end
end

command 'mar:app:env set' do |c|
  c.syntax = 'qtc-cli mar:app:env set INSTANCE_ID KEY=value'
  c.description = 'Set environment variable'
  c.action do |args, options|
    raise ArgumentError.new('INSTANCE_ID is required') if args[0].nil?
    raise ArgumentError.new("You didn't specify any values") if args[1].nil?
    Qtc::Cli::Mar::Env.new.set(args[0], args[1])
  end
end