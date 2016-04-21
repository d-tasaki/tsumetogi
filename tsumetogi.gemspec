# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tsumetogi/version'

Gem::Specification.new do |spec|
  spec.name          = "tsumetogi"
  spec.version       = Tsumetogi::VERSION
  spec.authors       = ["Daisuke TASAKI"]
  spec.email         = ["tasaki@i3-systems.com"]

  spec.summary       = %q{Slicing a PDF into images}
  spec.description   = %q{Slicing a PDF into images}
  spec.homepage      = "https://github.com/devchick/tsumetogi"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor'
  spec.add_dependency 'rmagick'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
