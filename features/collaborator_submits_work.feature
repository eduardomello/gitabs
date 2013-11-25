
Feature: Collaborator submits work

	A collaborator must be able to submit a task branch so that it 
	registers on its related metadata the end of the execution.
	
	the files from task must be merged back on the work branch
	and the metabranch must not have its tree altered.
	
	Scenario: list submit command help
		When I run `gitabs submit help`
		Then the output should contain "Use this command to submit a finished work"
