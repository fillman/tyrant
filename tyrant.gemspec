lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tyrant/version'

Gem::Specification.new do |spec|
  spec.name          = "tyrant"
  spec.version       = Tyrant::VERSION
  spec.authors       = ["Nick Sutterer"]
  spec.email         = ["apotonick@gmail.com"]

  spec.summary       = %q{Agnostic authorization for Trailblazer.}
  spec.description   = %q{Agnostic authorization component for Trailblazer.}
  spec.homepage      = "http://github.com/apotonick/tyrant"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry"

  spec.add_dependency "trailblazer", "~> 2.1.0.beta2"
  spec.add_dependency "reform", "~> 2.2.4"
  spec.add_dependency "dry-validation"
  spec.add_dependency "disposable", "~> 0.4.3"

  spec.add_dependency "warden", "~> 1.2.7"
  spec.add_dependency "bcrypt"
end
