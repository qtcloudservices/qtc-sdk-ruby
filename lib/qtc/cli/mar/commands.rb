require_relative 'apps'
require_relative 'domains'
require_relative 'ssl_certificates'
require_relative 'env'
require_relative 'repository'

command 'mar list' do |c|
  c.syntax = 'qtc-cli mar list'
  c.description = 'List all apps'
  c.action do |args, options|
    Qtc::Cli::Mar::Apps.new.list
  end
end

command 'mar show' do |c|
  c.syntax = 'qtc-cli mar show'
  c.description = 'Show app details'
  c.example 'Show app details for app with instance id: mar-eu-1-example', 'qtc-cli mar show --app mar-eu-1-example'
  c.option '--app APP', String, 'App instance id'
  c.option '--remote REMOTE', String, 'Git remote to use, eg "staging"'
  c.action do |args, options|
    Qtc::Cli::Mar::Apps.new.show(options)
  end
end

command 'mar restart' do |c|
  c.syntax = 'qtc-cli mar restart'
  c.description = 'Restart app'
  c.option '--app APP', String, 'App instance id'
  c.option '--remote REMOTE', String, 'Git remote to use, eg "staging"'
  c.action do |args, options|
    Qtc::Cli::Mar::Apps.new.restart(options)
  end
end

command 'mar create' do |c|
  c.syntax = 'qtc-cli mar create CLOUD_ID NAME'
  c.description = 'Create a new app instance'
  c.option '--size SIZE', String, 'App runtime size'
  c.option '--datacenter DATACENTER', String, 'Datacenter id'
  c.action do |args, options|
    raise ArgumentError.new('CLOUD_ID is required') if args[0].nil?
    raise ArgumentError.new('NAME is required') if args[1].nil?
    Qtc::Cli::Mar::Apps.new.create(args[0], args[1], options)
  end
end


command 'mar scale' do |c|
  c.syntax = 'qtc-cli mar scale KEY=VALUE'
  c.description = 'Scale app processes'
  c.option '--app APP', String, 'App instance id'
  c.option '--remote REMOTE', String, 'Git remote to use, eg "staging"'
  c.action do |args, options|
    Qtc::Cli::Mar::Apps.new.scale(args, options)
  end
end

command 'mar logs' do |c|
  c.syntax = 'qtc-cli mar logs'
  c.description = 'List app log entries'
  c.option '--app APP', String, 'App instance id'
  c.option '--remote REMOTE', String, 'Git remote to use, eg "staging"'
  c.option '--timestamp', String, 'Include timestamp'
  c.option '--stream', String, 'stdout or stderr'
  c.option '--limit LIMIT', Integer, 'Limit'
  c.option '--offset OFFSET', Integer, 'Offset'
  c.action do |args, options|
    Qtc::Cli::Mar::Apps.new.logs(options)
  end
end

command 'mar domains' do |c|
  c.syntax = 'qtc-cli mar domains'
  c.description = 'List app domains'
  c.option '--app APP', String, 'App instance id'
  c.option '--remote REMOTE', String, 'Git remote to use, eg "staging"'
  c.action do |args, options|
    Qtc::Cli::Mar::Domains.new.list(options)
  end
end

command 'mar domains:add' do |c|
  c.syntax = 'qtc-cli mar domains:add DOMAIN'
  c.description = 'Add custom domain to app'
  c.option '--app APP', String, 'App instance id'
  c.option '--remote REMOTE', String, 'Git remote to use, eg "staging"'
  c.action do |args, options|
    raise ArgumentError.new('DOMAIN is required') if args[0].nil?
    Qtc::Cli::Mar::Domains.new.create(args[0], options)
  end
end

command 'mar domains:remove' do |c|
  c.syntax = 'qtc-cli domains:remove DOMAIN'
  c.description = 'Remove custom domain from app'
  c.option '--app APP', String, 'App instance id'
  c.option '--remote REMOTE', String, 'Git remote to use, eg "staging"'
  c.action do |args, options|
    raise ArgumentError.new('DOMAIN is required') if args[0].nil?
    Qtc::Cli::Mar::Domains.new.destroy(args[0], options)
  end
end

command 'mar envs' do |c|
  c.syntax = 'qtc-cli mar envs'
  c.description = 'List app environment variables'
  c.option '--app APP', String, 'App instance id'
  c.option '--remote REMOTE', String, 'Git remote to use, eg "staging"'
  c.action do |args, options|
    Qtc::Cli::Mar::Env.new.show(options)
  end
end

command 'mar envs:set' do |c|
  c.syntax = 'qtc-cli mar envs:set KEY=value'
  c.description = 'Set app environment variable'
  c.option '--app APP', String, 'App instance id'
  c.option '--remote REMOTE', String, 'Git remote to use, eg "staging"'
  c.action do |args, options|
    raise ArgumentError.new("You didn't specify any values") if args[0].nil?
    Qtc::Cli::Mar::Env.new.set(args, options)
  end
end

command 'mar ssl:add' do |c|
  c.syntax = 'qtc-cli mar ssl:add --key=<path_to_pem> --cert=<path_to_crt>'
  c.description = 'Add SSL certificate to app'
  c.option '--app APP', String, 'App instance id'
  c.option '--remote REMOTE', String, 'Git remote to use, eg "staging"'
  c.option '--key PATH', String, 'Path to private key file'
  c.option '--cert PATH', String, 'Path to certificate file'
  c.action do |args, options|
    raise ArgumentError.new("--key is required") unless options.key
    raise ArgumentError.new("--cert is required") unless options.cert
    Qtc::Cli::Mar::SslCertificates.new.create(options)
  end
end

command 'mar ssl:remove' do |c|
  c.syntax = 'qtc-cli mar remove-ssl-cert'
  c.description = 'Remove SSL certificate from app'
  c.option '--app APP', String, 'App instance id'
  c.option '--remote REMOTE', String, 'Git remote to use, eg "staging"'
  c.action do |args, options|
    Qtc::Cli::Mar::SslCertificates.new.destroy(options)
  end
end

command 'mar repo:purge_cache' do |c|
  c.syntax = 'qtc-cli mar repo:purge_cache'
  c.description = 'Delete remote repository build cache contents'
  c.option '--app APP', String, 'App instance id'
  c.option '--remote REMOTE', String, 'Git remote to use, eg "staging"'
  c.action do |args, options|
    Qtc::Cli::Mar::Repository.new.purge_cache(options)
  end
end

command 'mar repo:reset' do |c|
  c.syntax = 'qtc-cli mar repo:reset'
  c.description = 'Reset remote git repository'
  c.option '--app APP', String, 'App instance id'
  c.option '--remote REMOTE', String, 'Git remote to use, eg "staging"'
  c.action do |args, options|
    Qtc::Cli::Mar::Repository.new.reset(options)
  end
end