
Feature: Collaborator executes work

	A collaborator must be able to select a metadata, on a metabranch, and
	relate it to a work branch in order to execute a new work.
	
	This operation must result on a third branch, with both the selected 
	metabranch and work branch as parents. It's tree object must list the 
	same objects from the selected work branch.

	Scenario: list execute command help
		When I run `gitabs help execute`
		Then the output should contain "Use this command to execute some work out of a certain metadata"
	
	Scenario: run execute command with 0 arguments
		When I run `gitabs execute`
		Then the output should contain "No value provided for required options"
	
	Scenario: run execute command with name argument
		When I run `gitabs execute task`
		Then the output should contain "No value provided for required options"
		
	Scenario: run execute command with -w flag only
		When I run `gitabs execute -w branch-name`
		Then the output should contain "ERROR"
		
	Scenario: run execute but there is no metadata on current branch
		Given I am on a directory with a git repository
		And the current branch is not 'task-meta'	
		When I run `gitabs execute landing-page -w master`
		Then the output should contain "Provided branch is not a metabranch"
	
	@task-meta			
	Scenario: run execute but no branch exists for -w flag
		Given I am on a directory with a git repository		
		And current branch is 'task-meta'
		And the branch 'void-branch' does not exist
		When I run `gitabs execute landing-page -w void-branch`
		Then the output should contain "work branch not found"
		
	@task-meta	
	Scenario: create task branch
		Given I am on a directory with a git repository
		And current branch is 'task-meta'		
		When I run `gitabs execute landing-page -w master`
		Then the output should contain "new task branch 'landing-page' created"
		
		
