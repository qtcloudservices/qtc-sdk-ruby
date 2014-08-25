require_relative 'apps'
require_relative 'domains'
require_relative 'env'

command 'mar apps' do |c|
  c.syntax = 'qtc-cli mar apps'
  c.description = 'List all apps'
  c.action do |args, options|
    Qtc::Cli::Mar::Apps.new.list
  end
end

command 'mar apps:show' do |c|
  c.syntax = 'qtc-cli mar apps:show INSTANCE_ID'
  c.description = 'Show app details'
  c.action do |args, options|
    raise ArgumentError.new('INSTANCE_ID is required') if args[0].nil?
    Qtc::Cli::Mar::Apps.new.show(args[0])
  end
end

command 'mar apps:restart' do |c|
  c.syntax = 'qtc-cli mar apps:restart INSTANCE_ID'
  c.description = 'Restart app'
  c.action do |args, options|
    raise ArgumentError.new('INSTANCE_ID is required') if args[0].nil?
    Qtc::Cli::Mar::Apps.new.restart(args[0])
  end
end

command 'mar apps:launch' do |c|
  c.syntax = 'qtc-cli mar apps:create CLOUD_ID NAME'
  c.description = 'Launch a new app instance'
  c.option '--size SIZE', String, 'App runtime size'
  c.option '--datacenter DATACENTER', String, 'Datacenter id'
  c.action do |args, options|
    raise ArgumentError.new('CLOUD_ID is required') if args[0].nil?
    raise ArgumentError.new('NAME is required') if args[1].nil?
    Qtc::Cli::Mar::Apps.new.create(args[0], args[1], options)
  end
end


command 'mar apps:scale' do |c|
  c.syntax = 'qtc-cli mar apps:scale INSTANCE_ID KEY=VALUE'
  c.description = 'Scale app processes'
  c.action do |args, options|
    raise ArgumentError.new('INSTANCE_ID is required') if args[0].nil?
    Qtc::Cli::Mar::Apps.new.scale(args[0], args[1])
  end
end

command 'mar apps:logs' do |c|
  c.syntax = 'qtc-cli mar apps:logs INSTANCE_ID'
  c.description = 'Show log entries'
  c.option '--limit LIMIT', Integer, 'Limit'
  c.option '--offset OFFSET', Integer, 'Offset'
  c.action do |args, options|
    raise ArgumentError.new('INSTANCE_ID is required') if args[0].nil?
    Qtc::Cli::Mar::Apps.new.logs(args[0], options)
  end
end

command 'mar apps:domains' do |c|
  c.syntax = 'qtc-cli mar apps:domains INSTANCE_ID'
  c.description = 'List app domains'
  c.action do |args, options|
    raise ArgumentError.new('INSTANCE_ID is required') if args[0].nil?
    Qtc::Cli::Mar::Domains.new.list(args[0])
  end
end

command 'mar apps:domains add' do |c|
  c.syntax = 'qtc-cli mar apps:domains add INSTANCE_ID DOMAIN'
  c.description = 'Add custom domain to app'
  c.action do |args, options|
    raise ArgumentError.new('INSTANCE_ID is required') if args[0].nil?
    raise ArgumentError.new('DOMAIN is required') if args[1].nil?
    Qtc::Cli::Mar::Domains.new.create(args[0], args[1])
  end
end

command 'mar apps:domains remove' do |c|
  c.syntax = 'qtc-cli mar:app:domains remove INSTANCE_ID DOMAIN'
  c.description = 'Remove custom domain from app'
  c.action do |args, options|
    raise ArgumentError.new('INSTANCE_ID is required') if args[0].nil?
    raise ArgumentError.new('DOMAIN is required') if args[1].nil?
    Qtc::Cli::Mar::Domains.new.destroy(args[0], args[1])
  end
end

command 'mar apps:env' do |c|
  c.syntax = 'qtc-cli mar apps:env INSTANCE_ID'
  c.description = 'Show app environment variables'
  c.action do |args, options|
    raise ArgumentError.new('INSTANCE_ID is required') if args[0].nil?
    Qtc::Cli::Mar::Env.new.show(args[0])
  end
end

command 'mar apps:env set' do |c|
  c.syntax = 'qtc-cli mar apps:env set INSTANCE_ID KEY=value'
  c.description = 'Set app environment variable'
  c.action do |args, options|
    raise ArgumentError.new('INSTANCE_ID is required') if args[0].nil?
    raise ArgumentError.new("You didn't specify any values") if args[1].nil?
    Qtc::Cli::Mar::Env.new.set(args[0], args[1])
  end
end