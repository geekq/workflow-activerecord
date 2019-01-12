[![Version
](https://img.shields.io/gem/v/workflow-activerecord.svg?maxAge=2592000)](https://rubygems.org/gems/workflow-activerecord)
[![Build Status
](https://travis-ci.org/geekq/workflow-activerecord.svg)](https://travis-ci.org/geekq/workflow-activerecord)
<!-- TODO find out how to add this repository without giving cloudclimate write access to the repo
[![Code Climate
](https://codeclimate.com/github/geekq/workflow-activerecord/badges/gpa.svg)](https://codeclimate.com/github/geekq/workflow-activerecord)
[![Test
Coverage](https://codeclimate.com/github/geekq/workflow-activerecord/badges/coverage.svg)](https://codeclimate.com/github/geekq/workflow-activerecord/coverage)
-->

# workflow-activerecord

**ActiveRecord/Rails Integration for the Workflow library**

Major+minor versions of workflow-activerecord are based on the oldest
compatible ActiveRecord API.  To use [`workflow`][] with a
Rails/ActiveRecord 4.1, 4.2, 5.0, 5.1, 5.2 please use:

    gem 'workflow-activerecord', '>= 4.1', '< 6.0'

This will also automatically include the newest compatible version of
the core 'workflow' gem. But you can also choose a specific version:

    gem 'workflow', '~> 2.0'
    gem 'workflow-activerecord', '>= 4.1pre', '< 6.0'

Please also have a look at the [sample application][]!

For detailed introduction into workflow DSL please read [`workflow`][]!

[`workflow`](https://github.com/geekq/workflow)
[sample application](https://github.com/geekq/workflow-rails-sample)


State persistence with ActiveRecord
-----------------------------------

Workflow library can handle the state persistence fully automatically. You
only need to define a string field on the table called `workflow_state`
and include the workflow mixin in your model class as usual:

    class Order < ApplicationRecord
      include Workflow
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
      include Workflow
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
      include Workflow

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


Changelog
---------

### New in the version 4.1.0

First version supporting Rails/ActiveRecord 4.1, 4.2, 5.0, 5.1, 5.2
Special thanks to https://github.com/voltechs for implementing Rails 5 support
and helping to revive `workflow`!

Support
-------

### Reporting bugs

<http://github.com/geekq/workflow/issues>


About
-----

Author: Vladimir Dobriakov, <https://infrastructure-as-code.de>

Copyright (c) 2010-2019 Vladimir Dobriakov and Contributors

Copyright (c) 2008-2009 Vodafone

Copyright (c) 2007-2008 Ryan Allen, FlashDen Pty Ltd

Based on the work of Ryan Allen and Scott Barron

Licensed under MIT license, see the LICENSE file.
