Feature: Project Manager creates a meta-branch
	
	As a project manager I want to create a meta-branch on some 
	repository so i can start storing meta-data on it
	
	Scenario: create a meta-branch
		Given I on a git repository
		When I create a meta-branch
		Then I should be able do checkout this new branch
		And I should see a single json-schema file on the branch
