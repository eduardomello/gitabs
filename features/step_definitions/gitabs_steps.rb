require 'rugged'
require 'minitest/autorun'
require 'minitest/spec'
World(MiniTest::Assertions)
MiniTest::Spec.new(nil)

Given(/^I am on a directory with a git repository$/) do
  output = capture_subprocess_io{ system('git branch') }.join ''
  output.must_match /.*master.*/
end

