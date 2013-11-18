Feature: Project Manager creates a meta-branch
	
	As a project manager I want to create a meta-branch on some 
	repository so i can start storing meta-data on it
	
	Scenario: list metabranch command help
		Given I am on a git repository
		When I run metabranch command
		Then I should see 'Use this command to create and edit metabranches'
			
#	Scenario: create a metabranch
#		Given I am on a git repository
#		When I create a metabranch
#		Then I should see 'new metabranch created'
		
	
