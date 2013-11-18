require 'rugged'

Given(/^I am on a git repository$/) do
	repo = Rugged::Repository.new('.')	  
end

When(/^I run metabranch command$/) do
	Gitabs::CLI.start ['metabranch']
end

Then(/^I should see 'Use this command to create and edit metabranches'$/) do
  pending # express the regexp above with the code you wish you had
end

