
Feature: Project Manager creates a meta-branch
	
	A project manager must be able to create a metabranch on some 
	repository so he can start storing metadata on it.
	
	To create a metabranch you need to provide a valid json-schema file
	which will validate future metadata. 
	
	When a metabranch was just created, gitabs manipulate the commit history
	in order to have a single file: the json-schema provided in its creation.
	
	The json schema will be renamed to the metabranch name and its extension
	changed to .schema in order to indetify it.
	
	Scenario: list metabranch command help
		When I run `gitabs help metabranch`
		Then the output should contain "Use this command to create and edit metabranches"
			
	Scenario: run metabranch command with 0 arguments
		When I run `gitabs metabranch`
		Then the output should contain "ERROR"
	
	@one-metabranch	
	Scenario: try to load metabranch (1 argument) and it exists
		When I run `gitabs metabranch users-meta`
		Then the output should contain "Loaded metabranch 'users-meta'"
		
	Scenario: try to load metabranch (1 argument) and it doesn't exist
		When I run `gitabs metabranch users-meta`
		Then the output should contain "Metabranch doesn't exist"	
	
	Scenario: run metabranch command with file and size option
		When I run `gitabs metabranch users-meta -f assets/json-schema/user-schema.json -s`
		Then the output should contain "ERROR"
		
	Scenario: run metabranch command with file option
		Given I am on a directory with a git repository
		And a file named "assets/json-schema/user-schema.json" with:
			"""
			{
				"$schema": "http://json-schema.org/draft-04/schema#",
				"title": "User",
				"description": "A User",
				"type": "object",
				"properties": {
					  	"name": {
					  		"description": "The user name",
					  		"type": "string"
					  	},
					  	"e-mail": {
					  		"description": "The user e-mail",
					  		"type": "string"
					  	}  
				},
				"required": ["name", "e-mail"]    
			}
			"""
		When I run `gitabs metabranch users-meta -f assets/json-schema/user-schema.json`
		Then the output should contain "Metabranch created"
		And I run `gitabs metabranch users-meta`
		And the output should contain "Loaded metabranch 'users-meta'"
		And I run `gitabs metabranch users-meta -s`
		And the output should contain "0 metadata records"
			
	Scenario: run metabranch command with invalid json-schema as file option
		Given I am on a directory with a git repository
		When I run `gitabs metabranch users-meta -f assets/json/invalid.json`
		Then the output should contain "Invalid JSON-Schema"
		
		
	
