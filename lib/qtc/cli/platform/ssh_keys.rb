require 'qtc/client'
require_relative '../common'

module Qtc::Cli::Platform
  class SshKeys
    include Qtc::Cli::Common

    def list
      response = platform_client.get('/user/ssh_keys')
      response['results'].each do |ssh_key|
        say "~ #{ssh_key['name']}"
      end
    end

    def create(options)
      raise ArgumentError.new('--name is required') if options.name.nil?
      raise ArgumentError.new('--key is required') if options.key.nil?
      unless File.exists?(options.key)
        raise ArgumentError.new("#{options.key} does not exist")
      end

      data = {
        name: options.name,
        key: File.read(options.key)
      }

      platform_client.post('/user/ssh_keys', data)
    end

    def destroy(options)
      raise ArgumentError.new('--name is required') if options.name.nil?
      response = platform_client.get('/user/ssh_keys')
      matches = response['results'].select{|r| r['name'] == options.name}
      if matches.size == 0
        raise ArgumentError.new("SSH key with name #{options.name} does not exist")
      else
        platform_client.delete("/user/ssh_keys/#{matches[0]['id']}")
      end
    end
  end
end
