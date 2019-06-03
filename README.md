[![Version
](https://img.shields.io/gem/v/workflow-activerecord.svg?maxAge=2592000)](https://rubygems.org/gems/workflow-activerecord)
[![Build Status
](https://travis-ci.org/geekq/workflow-activerecord.svg)](https://travis-ci.org/geekq/workflow-activerecord)
[![Code Climate](https://codeclimate.com/github/geekq/workflow-activerecord/badges/gpa.svg)](https://codeclimate.com/github/geekq/workflow-activerecord)
[![Test Coverage](https://codeclimate.com/github/geekq/workflow-activerecord/badges/coverage.svg)](https://codeclimate.com/github/geekq/workflow-activerecord/coverage)

# workflow-activerecord

**ActiveRecord/Rails Integration for the Workflow library**

Major+minor versions of workflow-activerecord are based on the oldest
compatible ActiveRecord API. To use [`workflow`][workflow] with
Rails/ActiveRecord 4.1, 4.2, 5.0, 5.1, 5.2 please use:

    gem 'workflow-activerecord', '>= 4.1', '< 6.0'

This will also automatically include the newest compatible version of
the core 'workflow' gem. But you can also choose a specific version:

    gem 'workflow', '~> 2.0'
    gem 'workflow-activerecord', '>= 4.1pre', '< 6.0'

Please also have a look at [the sample application][]!

For detailed introduction into workflow DSL please read the
[`workflow` README][workflow]!

[workflow]: https://github.com/geekq/workflow
[the sample application]: https://github.com/geekq/workflow-rails-sample


State persistence with ActiveRecord
-----------------------------------

Workflow library can handle the state persistence fully automatically. You
only need to define a string field on the table called `workflow_state`
and include the workflow mixin in your model class as usual:

    class Order < ApplicationRecord
      include WorkflowActiverecord
      workflow do
        # list states and transitions here
      end
    end

On a database record loading all the state check methods e.g.
`article.state`, `article.awaiting_review?` are immediately available.
For new records or if the `workflow_state` field is not set the state
defaults to the first state declared in the workflow specification. In
our example it is `:new`, so `Article.new.new?` returns true and
`Article.new.approved?` returns false.

At the end of a successful state transition like `article.approve!` the
new state is immediately saved in the database.

You can change this behaviour by overriding `persist_workflow_state`
method.

### Scopes

Workflow library also adds automatically generated scopes with names based on
states names:

    class Order < ApplicationRecord
      include WorkflowActiverecord
      workflow do
        state :approved
        state :pending
      end
    end

    # returns all orders with `approved` state
    Order.with_approved_state

    # returns all orders with `pending` state
    Order.with_pending_state


### Custom workflow database column

[meuble](http://imeuble.info/) contributed a solution for using
custom persistence column easily, e.g. for a legacy database schema:

    class LegacyOrder < ApplicationRecord
      include WorkflowActiverecord

      workflow_column :foo_bar # use this legacy database column for
                               # persistence
    end



### Single table inheritance

Single table inheritance is also supported. Descendant classes can either
inherit the workflow definition from the parent or override with its own
definition.


Custom Versions of Existing Adapters
------------------------------------

Other adapters (such as a custom ActiveRecord plugin) can be selected by adding a `workflow_adapter` class method, eg.

```ruby
class Example < ApplicationRecord
  def self.workflow_adapter
    MyCustomAdapter
  end
  include Workflow

  # ...
end
```

(The above will include `MyCustomAdapter` *instead* of the default
`WorkflowActiverecord` adapter.)


Multiple Workflows
------------------

I am frequently asked if it's possible to represent multiple "workflows"
in an ActiveRecord class.

The solution depends on your business logic and how you want to
structure your implementation.

### Use Single Table Inheritance

One solution can be to do it on the class level and use a class
hierarchy. You can use [single table inheritance][STI] so there is only
single `orders` table in the database. Read more in the chapter "Single
Table Inheritance" of the [ActiveRecord documentation][ActiveRecord].
Then you define your different classes:

    class Order < ActiveRecord::Base
      include WorkflowActiverecord
    end

    class SmallOrder < Order
      workflow do
        # workflow definition for small orders goes here
      end
    end

    class BigOrder < Order
      workflow do
        # workflow for big orders, probably with a longer approval chain
      end
    end


### Individual workflows for objects

Another solution would be to connect different workflows to object
instances via metaclass, e.g.

    # Load an object from the database
    booking = Booking.find(1234)

    # Now define a workflow - exclusively for this object,
    # probably depending on some condition or database field
    if # some condition
      class << booking
        include WorkflowActiverecord
        workflow do
          state :state1
          state :state2
        end
      end
    # if some other condition, use a different workflow

You can also encapsulate this in a class method or even put in some
ActiveRecord callback. Please also have a look at [the full working
example][multiple_workflow_test]!

### on_transition

You can have a look at an advanced [`on_transition`][] example in
[this test file][advanced_hooks_and_validation_test].

[STI]: http://www.martinfowler.com/eaaCatalog/singleTableInheritance.html
[ActiveRecord]: http://api.rubyonrails.org/classes/ActiveRecord/Base.html
[multiple_workflow_test]: https://github.com/geekq/workflow-activerecord/blob/develop/test/multiple_workflows_test.rb
[`on_transition`]: https://github.com/geekq/workflow#on_transition
[advanced_hooks_and_validation_test]: http://github.com/geekq/workflow-activerecord/blob/develop/test/advanced_hooks_and_validation_test.rb

Changelog
---------

### New in the version 4.1.6

* gh-3, gh-5 allow automatic require of workflow-activerecord - no need for explicit `require` anymore

### New in the version 4.1.5

* gh-2 Show code coverage on codeclimate
* gh-7 Improve require for base `workflow`

### New in the version 4.1.3

* retire Ruby 2.3 and Rails 4.1 since this Ruby version has reached end of life
* add build for Rails 6.0 beta, Ruby 2.6
* fix #4 ruby-graphiz warnings

### New in the version 4.1.0

First version supporting Rails/ActiveRecord 4.1, 4.2, 5.0, 5.1, 5.2
Special thanks to [@voltechs][] for implementing Rails 5 support
and helping to revive `workflow`!

[@voltechs]: https://github.com/voltechs

Support
-------

### Reporting bugs

<http://github.com/geekq/workflow-activerecord/issues>


About
-----

Author: Vladimir Dobriakov, <https://infrastructure-as-code.de>

Copyright (c) 2010-2019 Vladimir Dobriakov and Contributors

Copyright (c) 2008-2009 Vodafone

Copyright (c) 2007-2008 Ryan Allen, FlashDen Pty Ltd

Based on the work of Ryan Allen and Scott Barron

Licensed under MIT license, see the LICENSE file.
