require_relative 'lib/workflow_activerecord/version'

Gem::Specification.new do |gem|
  gem.name          = "workflow-activerecord"
  gem.version       = WorkflowActiverecord::VERSION
  gem.authors       = ["Vladimir Dobriakov"]
  gem.email         = ["vladimir@geekq.net"]
  gem.description   = <<~DESC
                        ActiveRecord/Rails Integration for the Workflow library.
                        Workflow is a finite-state-machine-inspired API for modeling and interacting
                        with what we tend to refer to as 'workflow'.
                      DESC
  gem.summary       = %q{ActiveRecord/Rails Integration for the Workflow library.}
  gem.licenses      = ['MIT']
  gem.homepage      = "https://github.com/geekq/workflow-activerecord"

  gem.files         = Dir['CHANGELOG.md', 'README.md', 'LICENSE', 'lib/**/*']
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.extra_rdoc_files = [
    "README.md"
  ]

  rails_versions = ['>= 3.0', '< 6.1']

  gem.required_ruby_version = '>= 2.3'

  gem.add_runtime_dependency 'workflow', '~> 2.0'
  gem.add_runtime_dependency 'activerecord', rails_versions

  gem.add_development_dependency 'rdoc',          '~> 6.1'
  gem.add_development_dependency 'bundler',       '~> 2.0'
  gem.add_development_dependency 'mocha',         '~> 1.8'
  gem.add_development_dependency 'rake',          '~> 12.3'
  gem.add_development_dependency 'minitest',      '~> 5.11'
  gem.add_development_dependency 'sqlite3',       '~> 1.3'
end

