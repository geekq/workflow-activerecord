require 'rubygems'
require 'workflow'
require 'workflow/specification'
require 'workflow_activerecord/adapters/active_record'

module WorkflowActiverecord
  def self.included(klass)
    klass.send :include, ::Workflow
    klass.send :include, Adapter::ActiveRecord
  end
end
