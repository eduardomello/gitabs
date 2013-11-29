
Feature: Collaborator submits task

	A collaborator must be able to submit a task branch so that it 
	registers on its related metadata the end of the execution.
	
	The files from task branch must be merged back on the work branch
	and the metabranch must not have its tree altered.
	
	Scenario: list submit command help
		When I run `gitabs help submit`
		Then the output should contain "Use this command to submit a finished work"
		
	Scenario: run submit command with 0 arguments
		When I run `gitabs submit`
		Then the output should contain "No value provided for required options"

	@execute-task	
	Scenario: run submit command with 1 argument
		When I run `gitabs submit -m "this work is done"`
		Then the output should contain "Task submitted"
