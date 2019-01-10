require 'rubygems'

require 'workflow/specification'
require 'workflow_activerecord/adapters/active_record'

begin
  require 'ruby-graphviz'
  require 'active_support/inflector'
  require 'workflow/draw'
rescue LoadError => e
  $stderr.puts "Could not load the ruby-graphiz or active_support gems for rendering: #{e.message}"
end

module WorkflowActiverecord
  def self.included(klass)
    klass.send :include, ::Workflow
    klass.send :include, Adapter::ActiveRecord
  end
end
