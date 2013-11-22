
Feature: Collaborator creates metadata

	A collaborating peer in the project must be able to create metadata
	in a certain metabranch so he may document the project.
	
	To create a metadata, there must be a previous metabranch created
	and there must be a json valid file under the schema of that metabranch.
	
	Scenario: list metadata command help
		When I run `gitabs help metadata`
		Then the output should contain "Use this command to add metadata in a certain metabranch"
		
	Scenario: run metadata command with 0 arguments
		When I run `gitabs metadata`
		Then the output should contain "No value provided for required options"
		
	Scenario: add valid metadata on current branch
		Given I am on a directory with a git repository
		And a file named "assets/json/john-doe.json" with:
		"""
		{
			"name": "John Doe",
			"e-mail": "john@doe.com"
		}
		"""
		When I run `gitabs metadata -f assets/json/john-doe.json`
		Then the output should contain "Metadata created"
		
	Scenario: add invalid json file on current branch
		Given I am on a directory with a git repository
		And a file named "assets/json/invalid.json" with:
		"""
		{		
			value:"value"
		"""
		When I run `gitabs metadata -f assets/json/invalid.json`
		Then the output should contain "Invalid JSON file"
		
	Scenario: add valid json file with more fields then expected by the metabranch schema
		Given I am on a directory with a git repository
		And a file named "assets/json/john-doe-more-fields.json" with:
		"""
		{
			"name": "John Doe",
			"e-mail": "john@doe.com",
			"username": "johndoe"
		}
		"""
		When I run `gitabs metadata -f assets/json/john-doe-more-fields.json`
		Then the output should contain "JSON file not accepted on this metabranch"

	Scenario: add valid json file without required fields by the metabranch schema
		Given I am on a directory with a git repository
		And a file named "assets/json/john-doe-more-fields.json" with:
		"""
		{
			"name": "John Doe"
		}
		"""
		Then the output should contain "JSON file not accepted on this metabranch"
