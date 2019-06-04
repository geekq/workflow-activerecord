warn <<HERE

DEPRECATED: `require 'workflow_activerecord'` is obsolete. Usually you can just
remove the require line. In Rails, adding gem to Gemfile should be enough.
`bundle.require` will take care. If you need to require explicitely, use
workflow-activerecord (with dash) instead. The module with underscore will be
deleted on 4.2 release."

HERE

require_relative 'workflow-activerecord'
