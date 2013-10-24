# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tank_girl/version'

Gem::Specification.new do |spec|
  spec.name          = "tank_girl"
  spec.version       = TankGirl::VERSION
  spec.authors       = ["Victor Martinez"]
  spec.email         = ["knoopx@gmail.com"]
  spec.description   = %q{TankGirl brings heavy machinery for your Cucumber/Turnip steps}
  spec.summary       = %q{TankGirl brings heavy machinery for your Cucumber/Turnip steps}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 3.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
