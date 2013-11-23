require 'minitest/autorun'
require 'minitest/spec'
require 'gitabs/metabranch'

World(MiniTest::Assertions)
MiniTest::Spec.new(nil)

Given(/^I am on a directory with a git repository$/) do
  output = capture_subprocess_io{ system('git branch') }.join ''
  output.must_match /.*master.*/
end

Given(/^this repository has a metabranch named 'users\-meta'$/) do
  mb = Gitabs::Metabranch.new('users-meta')
  mb.branch.wont_be_nil
end

Given(/^current branch is 'tasks\-meta'$/) do
  output = capture_io { `git rev-parse --abbrev-ref HEAD`}.join ''
  output.must_match 'task-meta'
end

