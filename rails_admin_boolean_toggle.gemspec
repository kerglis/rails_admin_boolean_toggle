# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_admin_boolean_toggle/version'

Gem::Specification.new do |spec|
  spec.name          = 'rails_admin_boolean_toggle'
  spec.version       = RailsAdminBooleanToggle::VERSION
  spec.authors       = ['Kristaps Erglis']
  spec.email         = ['kristaps.erglis@gmail.com']
  spec.description   = %q{Toggle model's boolean values from list within rails_admin}
  spec.summary       = %q{Toggle model's boolean values from list within rails_admin}
  spec.homepage      = 'https://github.com/kerglis/rails_admin_boolean_toggle'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails_admin'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
