# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ar_pagination/version'

Gem::Specification.new do |spec|
  spec.name          = "ar_pagination"
  spec.version       = ArPagination::VERSION
  spec.authors       = ["Madeline Carson"]
  spec.email         = ["madeline.carson@gmail.com"]
  spec.summary       = %q{Pagination for Rails controllers. Includes cursor pagination and offset pagination.}
  spec.description   = %q{Pagination for Rails controllers.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "rails"
  spec.add_development_dependency "pg"
  spec.add_development_dependency "activesupport"
end
