# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'anticuado/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 2.1"
  spec.name          = "anticuado"
  spec.version       = Anticuado::VERSION
  spec.authors       = ["Kazuaki MATSUO"]
  spec.email         = ["fly.49.89.over@gmail.com"]

  spec.summary       = %q{Collect and arrange some outdated libraries for several platforms}
  spec.description   = %q{Collect and arrange some outdated libraries for several platforms}
  spec.homepage      = "https://github.com/KazuCocoa/anticuado"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "git", "~> 1.3.0"
  spec.add_runtime_dependency "octokit", "~> 4.8.0"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry"
end
