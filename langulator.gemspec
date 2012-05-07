# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Katrina Owen"]
  gem.email         = ["katrina.owen@gmail.com"]
  gem.description   = %q{Manage, maintain, and munge your i18n files.}
  gem.summary       = %q{Tasks to keep your i18n files managable.}
  gem.homepage      = "http://github.com/kytrinyx/langulator"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "langulator"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.4"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "cucumber"
  gem.add_runtime_dependency "thor"
end
