# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'generators/mongoid_model_maker/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid-model-maker"
  spec.version       = MongoidModelMaker::VERSION
  spec.authors       = ["David Wilcox"]
  spec.email         = ["dave@davidgwilcox.com"]
  spec.description   = %q{A Rails generator to help produce large quantities of Models, with relationships, from a yaml source file.}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/Dawil/MongoidModelMaker"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rails", "~> 4.0.0"
end
