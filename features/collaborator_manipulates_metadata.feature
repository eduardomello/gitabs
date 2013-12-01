Feature: Collaborator manipulates metadata

	A collaborator must be able to manipulate metadata in a certain
	 metabranch so he may register information on the project.
	
	To create a metadata, there must be a previous metabranch created
	and there must be a json schema-valid file for that metabranch.
	The input file will be renamed after the provided name argument. 
	Also, it will have its extension as .data, to difference the .schema 
	extension.

	Scenario: list metadata command help
		When I run `gitabs help metadata`
		Then the output should contain "Use this command to add metadata in a certain metabranch"
		
	Scenario: run metadata command with 0 arguments
		When I run `gitabs metadata`
		Then the output should contain "No value provided for required options"
	
	@one-metabranch	
	Scenario: add valid metadata on current branch
		Given I am on a directory with a git repository
		And this repository has a metabranch named 'users-meta'
		And a file named "assets/json/john-doe.json" with:
		"""
		{
			"name": "John Doe",
			"e-mail": "john@doe.com"
		}
		"""
		When I run `gitabs metadata john-doe -f assets/json/john-doe.json`
		Then the output should contain "Metadata created"
		
	@one-metabranch		
	Scenario: add invalid json file on current branch
		Given I am on a directory with a git repository		
		And a file named "assets/json/invalid.json" with:
		"""
		{		
			value:"value"
		"""
		When I run `gitabs metadata john-doe -f assets/json/invalid.json`
		Then the output should contain "Invalid JSON file"
	
	@one-metabranch	
	Scenario: add valid json file with more fields then expected by the metabranch schema
		Given I am on a directory with a git repository
		And this repository has a metabranch named 'users-meta'
		And a file named "assets/json/john-doe-more-fields.json" with:
		"""
		{
			"name": "John Doe",
			"e-mail": "john@doe.com",
			"username": "johndoe"
		}
		"""
		When I run `gitabs metadata john-doe -f assets/json/john-doe-more-fields.json`
		Then the output should contain "JSON file not accepted on this metabranch"

	@one-metabranch	
	Scenario: add valid json file without required fields by the metabranch schema
		Given I am on a directory with a git repository
		And this repository has a metabranch named 'users-meta'
		And a file named "assets/json/john-doe-required-problem.json" with:
		"""
		{
			"name": "John Doe"
		}
		"""
		When I run `gitabs metadata john-doe -f assets/json/john-doe-required-problem.json`
		Then the output should contain "JSON file not accepted on this metabranch"
