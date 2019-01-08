require_relative 'lib/workflow_activerecord/version'

Gem::Specification.new do |gem|
  gem.name          = "workflow-activerecord"
  gem.version       = WorkflowActiverecord::VERSION
  gem.authors       = ["Vladimir Dobriakov"]
  gem.email         = ["vladimir@geekq.net"]
  gem.description   = "ActiveRecord/Rails Integration for the Workflow library. \nWorkflow is a finite-state-machine-inspired API for modeling and interacting\n    with what we tend to refer to as 'workflow'."
  gem.summary       = %q{ActiveRecord/Rails Integration for the Workflow library.}
  gem.licenses      = ['MIT']
  gem.homepage      = "http://www.geekq.net/workflow/"

  gem.files         = Dir['CHANGELOG.md', 'README.md', 'LICENSE', 'lib/**/*']
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.extra_rdoc_files = [
    "README.md"
  ]

  rails_versions = ['>= 3.0', '< 6']

  gem.required_ruby_version = '>= 2.3'

  gem.add_runtime_dependency 'workflow', '~> 2.0a'
  gem.add_runtime_dependency 'activerecord', rails_versions

  gem.add_development_dependency 'rdoc',    [">= 3.12"]
  gem.add_development_dependency 'bundler', [">= 1.0.0"]
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'mocha'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'test-unit'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'ruby-graphviz'

end

