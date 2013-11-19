require 'rugged'
require 'minitest/spec'
World(MiniTest::Assertions)
MiniTest::Spec.new(nil)

Given(/^I am on directory with a git repository$/) do
  output = capture_subprocess_io{ system('git branch') }.join ''
  output.must_match /.*master.*/
end

