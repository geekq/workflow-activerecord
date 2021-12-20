require File.join(File.dirname(__FILE__), 'test_helper')

$VERBOSE = false
require 'active_record'
require 'sqlite3'
require 'workflow'
require 'mocha/minitest'
require 'stringio'

ActiveRecord::Migration.verbose = false

class Order < ActiveRecord::Base
  include WorkflowActiverecord
  workflow do
    state :submitted do
      event :accept, :transitions_to => :accepted, :meta => {:weight => 8} do |reviewer, args|
      end
    end
    state :accepted do
      event :ship, :transitions_to => :shipped
    end
    state :shipped
  end
end

class LegacyOrder < ActiveRecord::Base
  include WorkflowActiverecord

  workflow_column :foo_bar # use this legacy database column for persistence

  workflow do
    state :submitted do
      event :accept, :transitions_to => :accepted, :meta => {:weight => 8} do |reviewer, args|
      end
    end
    state :accepted do
      event :ship, :transitions_to => :shipped
    end
    state :shipped
  end
end

class Image < ActiveRecord::Base
  include WorkflowActiverecord

  workflow_column :status

  workflow do
    state :unconverted do
      event :convert, :transitions_to => :converted
    end
    state :converted
  end
end

class SmallImage < Image
end

class SpecialSmallImage < SmallImage
end

class MainTest < ActiveRecordTestCase

  def setup
    super

    ActiveRecord::Schema.define do
      create_table :orders do |t|
        t.string :title, :null => false
        t.string :workflow_state
      end
    end

    exec "INSERT INTO orders(title, workflow_state) VALUES('some order', 'accepted')"

    ActiveRecord::Schema.define do
      create_table :legacy_orders do |t|
        t.string :title, :null => false
        t.string :foo_bar
      end
    end

    exec "INSERT INTO legacy_orders(title, foo_bar) VALUES('some order', 'accepted')"

    ActiveRecord::Schema.define do
      create_table :images do |t|
        t.string :title, :null => false
        t.string :state
        t.string :type
      end
    end
  end

  def assert_state(title, expected_state, klass = Order)
    o = klass.find_by_title(title)
    assert_equal expected_state, o.read_attribute(klass.workflow_column)
    o
  end

  test 'immediately save the new workflow_state on state machine transition' do
    o = assert_state 'some order', 'accepted'
    assert o.ship!
    assert_state 'some order', 'shipped'
  end

  test 'immediately save the new workflow_state on state machine transition with custom column name' do
    o = assert_state 'some order', 'accepted', LegacyOrder
    assert o.ship!
    assert_state 'some order', 'shipped', LegacyOrder
  end

  test 'persist workflow_state in the db and reload' do
    o = assert_state 'some order', 'accepted'
    assert_equal :accepted, o.current_state.name
    o.ship!
    o.save!

    assert_state 'some order', 'shipped'

    o.reload
    assert_equal 'shipped', o.read_attribute(:workflow_state)
  end

  test 'persist workflow_state in the db with_custom_name and reload' do
    o = assert_state 'some order', 'accepted', LegacyOrder
    assert_equal :accepted, o.current_state.name
    o.ship!
    o.save!

    assert_state 'some order', 'shipped', LegacyOrder

    o.reload
    assert_equal 'shipped', o.read_attribute(:foo_bar)
  end

  test 'default workflow column should be workflow_state' do
    o = assert_state 'some order', 'accepted'
    assert_equal :workflow_state, o.class.workflow_column
  end

  test 'custom workflow column should be foo_bar' do
    o = assert_state 'some order', 'accepted', LegacyOrder
    assert_equal :foo_bar, o.class.workflow_column
  end

  test 'access workflow specification' do
    assert_equal 3, Order.workflow_spec.states.length
    assert_equal ['submitted', 'accepted', 'shipped'].sort,
      Order.workflow_spec.state_names.map{|n| n.to_s}.sort
  end

  test 'current state object' do
    o = assert_state 'some order', 'accepted'
    assert_equal 'accepted', o.current_state.to_s
    assert_equal 1, o.current_state.events.length
  end

  test 'nil as initial state' do
    exec "INSERT INTO orders(title, workflow_state) VALUES('nil state', NULL)"
    o = Order.find_by_title('nil state')
    assert o.submitted?, 'if workflow_state is nil, the initial state should be assumed'
    assert !o.shipped?
  end

  test 'initial state immediately set as ActiveRecord attribute for new objects' do
    o = Order.create(:title => 'new object')
    assert_equal 'submitted', o.read_attribute(:workflow_state)
  end

  test 'question methods for state' do
    o = assert_state 'some order', 'accepted'
    assert o.accepted?
    assert !o.shipped?
  end

  test 'correct exception for event, that is not allowed in current state' do
    o = assert_state 'some order', 'accepted'
    assert_raises Workflow::NoTransitionAllowed do
      o.accept!
    end
  end

  test 'STI when parent changed the workflow_state column' do
    assert_equal 'status', Image.workflow_column.to_s
    assert_equal 'status', SmallImage.workflow_column.to_s
    assert_equal 'status', SpecialSmallImage.workflow_column.to_s
  end

  test 'Single table inheritance (STI)' do
    class BigOrder < Order
    end

    bo = BigOrder.new
    assert bo.submitted?
    assert !bo.accepted?
  end

  test 'Two-level inheritance' do
    class BigOrder < Order
    end

    class EvenBiggerOrder < BigOrder
    end

    assert EvenBiggerOrder.new.submitted?
  end

  test 'Iheritance with workflow definition override' do
    class BigOrder < Order
    end

    class SpecialBigOrder < BigOrder
      workflow do
        state :start_big
      end
    end

    special = SpecialBigOrder.new
    assert_equal 'start_big', special.current_state.to_s
  end
end
