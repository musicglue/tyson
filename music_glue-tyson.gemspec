# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "music_glue-tyson"
  spec.version       = '0.0.1'
  spec.authors       = ["Adam Carlile"]
  spec.email         = ["adam@benchmedia.co.uk"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency("omniauth-music_glue", [">= 0.1.0"])
  spec.add_runtime_dependency("sinatra", ["~> 1.0"])
  spec.add_runtime_dependency("rack", ["~> 1.0"])

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
