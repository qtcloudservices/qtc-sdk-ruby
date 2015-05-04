require_relative 'apps'
require_relative 'domains'
require_relative 'ssl_certificates'
require_relative 'env'
require_relative 'repository'
require_relative 'debug'
require_relative 'stack'
require_relative 'slugs'

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
  c.syntax = 'qtc-cli mar create NAME'
  c.description = 'Create a new app instance'
  c.option '--size SIZE', String, 'App runtime size'
  c.action do |args, options|
    raise ArgumentError.new('NAME is required') if args[0].nil?
    Qtc::Cli::Mar::Apps.new.create(args[0], options)
  end
end

command 'mar stack' do |c|
  c.syntax = 'qtc-cli mar stack'
  c.description = 'Get app stack'
  c.option '--app APP', String, 'App instance id'
  c.option '--remote REMOTE', String, 'Git remote to use, eg "staging"'
  c.action do |args, options|
    Qtc::Cli::Mar::Stack.new.show(args[0], options)
  end
end

command 'mar stack:set' do |c|
  c.syntax = 'qtc-cli mar stack:set STACK'
  c.description = 'Set app stack'
  c.option '--app APP', String, 'App instance id'
  c.option '--remote REMOTE', String, 'Git remote to use, eg "staging"'
  c.action do |args, options|
    raise ArgumentError.new('STACK is required') if args[0].nil?
    Qtc::Cli::Mar::Stack.new.update(args[0], options)
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
  c.option '--chain PATH', String, 'Path to certificate chain file'
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

command 'mar local:run' do |c|
  c.syntax = 'qtc-cli mar local:run'
  c.option '--clean', String, 'Force clean build'
  c.option '--stack STRING', String, 'Define used stack (default: cedar-14)'
  c.option '--branch STRING', String, 'Define used git branch (default: master)'
  c.description = 'Debug mar app locally (requires docker)'
  c.action do |args, options|
    Qtc::Cli::Mar::Debug.new.local_debug(args, options)
  end
end

command 'mar local:build_slug' do |c|
  c.syntax = 'qtc-cli mar local:build_slug'
  c.option '--stack STRING', String, 'Define used stack (default: cedar-14)'
  c.option '--branch STRING', String, 'Define used git branch (default: master)'
  c.description = 'Build mar app slug locally (requires docker)'
  c.action do |args, options|
    Qtc::Cli::Mar::Debug.new.local_build_slug(options)
  end
end

command 'mar exec' do |c|
  c.syntax = 'qtc-cli mar exec <cmd>'
  c.description = 'Execute command inside app process'
  c.option '--process PROCESS_ID', String, 'App process id'
  c.option '--app APP', String, 'App instance id'
  c.option '--remote REMOTE', String, 'Git remote to use, eg "staging"'
  c.action do |args, options|
    raise ArgumentError.new("command required") if args.size == 0
    raise ArgumentError.new("--process is required") unless options.process
    Qtc::Cli::Mar::Apps.new.exec(args.join(" "), options)
  end
end

command 'mar slug:upload' do |c|
  c.syntax = 'qtc-cli mar slug:upload --slug=<path to slug.tgz> --procfile=<path to Procfile> --tag <git hash or arbitrary unique tag>'
  c.description = 'Upload ready made slug into app'
  c.option '--app APP', String, 'App instance id'
  c.option '--slug SLUG', String, 'The path to the slug file'
  c.option '--procfile PROCFILE', String , 'The path to Procfile where the process types will be loaded'
  c.option '--tag TAG', String, 'The tag to identify the slug. Could be e.g. commit hash if CD system is uploading the slug'
  c.action do |args, options|
    raise ArgumentError.new("--slug is required") unless options.slug
    raise ArgumentError.new("--procfile is required") unless options.procfile
    raise ArgumentError.new("--tag is required") unless options.tag
    Qtc::Cli::Mar::Slugs.new.upload(options)
  end
end

command 'mar slug:deploy' do |c|
  c.syntax = 'qtc-cli mar slug:deploy <tag>'
  c.description = 'Deploy slug into app'
  c.option '--app APP', String, 'App instance id'
  c.action do |args, options|
    raise ArgumentError.new("Slug identifier tag required") if args.size == 0
    Qtc::Cli::Mar::Slugs.new.deploy(args[0], options)
  end
end

command 'mar slug:list' do |c|
  c.syntax = 'qtc-cli mar slug:list'
  c.description = 'Deploy slug into app'
  c.option '--app APP', String, 'App instance id'
  c.action do |args, options|
    Qtc::Cli::Mar::Slugs.new.list(options)
  end
end

command 'mar slug:remove' do |c|
  c.syntax = 'qtc-cli mar slug:remove <id>'
  c.description = 'Removes a slug from system'
  c.option '--app APP', String, 'App instance id'
  c.action do |args, options|
    raise ArgumentError.new("Slug identifier tag required") if args.size == 0
    Qtc::Cli::Mar::Slugs.new.remove(args[0], options)
  end
end
