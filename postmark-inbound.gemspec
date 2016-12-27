$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'postmark-inbound/version'


Gem::Specification.new do |s|
  s.name          = 'postmark-inbound'
  s.version       = PINS::Version
  s.authors       = ['Ken J.']
  s.email         = ['kenjij@gmail.com']
  s.summary       = %q{A Ruby server for Postmark inbound webhook.}
  s.description   = %q{A programable Ruby server for Postmark inbound webhook. For example, trigger notifications or automated response.}
  s.homepage      = 'https://github.com/kenjij/postmark-inbound'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 2.1.0'

  s.add_runtime_dependency 'kajiki', '~> 1.1'
  s.add_runtime_dependency 'sinatra', '~> 1.4'
end
