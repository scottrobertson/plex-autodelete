# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'plex/autodelete/version'

Gem::Specification.new do |spec|
  spec.name          = "plex-autodelete"
  spec.version       = Plex::Autodelete::VERSION
  spec.authors       = ["Scott Robertson"]
  spec.email         = ["scottymeuk@gmail.com"]
  spec.summary       = "Automatically removed watched episodes in Plex"
  spec.description   = "Automatically removed watched episodes in Plex"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency 'plex-ruby', '~> 1.5', '>= 1.5.1'
  spec.add_runtime_dependency 'thor', '~> 0.19.1'
  spec.add_runtime_dependency 'colorize', '~> 0.7.3'
  spec.add_runtime_dependency 'nori', '~> 2.4', '>= 2.4.0'
  spec.add_runtime_dependency 'mini_portile', '~> 0.6.1'
end
