# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qtc/version'

Gem::Specification.new do |spec|
  spec.name          = 'qtc-sdk'
  spec.version       = Qtc::VERSION
  spec.authors       = ['Jari Kolehmainen']
  spec.email         = ['jari.kolehmainen@digia.com']
  spec.summary       = %q{Qt Cloud Services SDK for Ruby}
  spec.description   = %q{Qt Cloud Services SDK for Ruby}
  spec.homepage      = 'https://github.com/jakolehm/qtc-sdk-ruby'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 1.9.3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14.0'
  spec.add_runtime_dependency 'httpclient', '~> 2.3'
  spec.add_runtime_dependency 'commander'
  spec.add_runtime_dependency 'inifile'
end
