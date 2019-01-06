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

To use `workflow` with a Rails 5.0 project you now need to include

    gem 'workflow-activerecord'

This will also automatically include the newest version of the core
'workflow' gem. But you can also choose a specific version:

    gem 'workflow', '~> 2.0'
    gem 'workflow-activerecord'
