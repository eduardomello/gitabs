
Feature: Project Manager creates a meta-branch
	
	As a project manager I want to create a meta-branch on some 
	repository so i can start storing meta-data on it.
	
	To create a metbranch you need to provide a valid json-schema file
	which will validate future metadata. 
	
	When a metabranch was just created, gitabs manipulate the commit history
	in order to have a single file: the json-schema provided in its creation.
	
	
	
	Scenario: list metabranch command help
		When I run `gitabs help metabranch`
		Then the output should contain "Use this command to create and edit metabranches"
			
	Scenario: run metabranch command with 0 arguments
		When I run `gitabs metabranch`
		Then the output should contain "ERROR"
		
	Scenario: run metabranch command with 1 argument 
		When I run `gitabs metabranch some-branch`
		Then the output should contain "Switched to branch 'some-branch'"
	
	Scenario: run metabranch command with file and size option
		When I run `gitabs metabranch some-branch -f assets/json-schema/users.json -s`
		Then the output should contain "ERROR"
		
	Scenario: run metabranch command with file option
		Given I am on directory with a git repository
		When I run `gitabs metabranch some-branch -f assets/json-schema/users.json`
		Then the output should contain "Metabranch created"
		And I run `gitabs metabranch some-branch`
		And the output should contain "Switched to branch 'some-branch'"
		And I run `gitabs metabranch some-branch -s`
		And the output should contain "0 metadata records"
			
	Scenario: run metabranch command with invalid json-schema as file option
		Given I am on directory with a git repository
		When I run `gitabs metabranch some-branch -f assets/json/invalid.json`
		Then the output should contain "Invalid JSON-Schema"
		
		
	
