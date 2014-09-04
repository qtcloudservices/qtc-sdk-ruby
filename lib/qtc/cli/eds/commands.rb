require_relative 'instances'

command 'eds list' do |c|
  c.syntax = 'qtc-cli eds list'
  c.description = 'List all EDS instances'
  c.action do |args, options|
    Qtc::Cli::Eds::Instances.new.list
  end
end

command 'eds create' do |c|
  c.syntax = 'qtc-cli eds create <CLOUD_ID> <NAME>'
  c.description = 'Create a new EDS instance'
  c.example 'Create new EDS instance "My Backend" to cloud "46738209-a745-4841-8eeb-1ca0672aa6v8"', 'qtc-cli eds create 46738209-a745-4841-8eeb-1ca0672aa6v8 "My Backend"'
  c.action do |args, options|
    raise ArgumentError.new('CLOUD_ID is required') if args[0].nil?
    raise ArgumentError.new('NAME is required') if args[1].nil?
    Qtc::Cli::Eds::Instances.new.create(args[0], args[1])
  end
end
