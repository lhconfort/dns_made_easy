# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dns_made_easy/version'

Gem::Specification.new do |s|
  s.name          = "dns_made_easy"
  s.version       = DnsMadeEasy::VERSION
  s.authors       = ["Matias Hick"]
  s.email         = ["me@unformatt.com.ar"]
  s.summary       = "Interacts dns made easy API"
  s.description   = "Interacts to dns made easy API"
  s.homepage      = "https://github.com/unformattmh/dns_made_easy"
  s.license       = "MIT"

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|s|features)/})
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", ">= 1.3"
  s.add_development_dependency "rake"

  s.add_runtime_dependency "rest-client", ">= 1.8"
end
