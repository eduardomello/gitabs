require 'gitabs'
require 'gitabs/git_controller'
require 'rugged'

module Gitabs
	class Task	
		attr_reader :metadata
		
		def initialize(metadata=nil)
			
			@git_controller = GitController.new	
			raise "No repository found" unless @git_controller.is_repo? 
			if metadata then
				@metadata = metadata
			else
				load_metadata
			end
			raise "Invalid metadata" unless metadata.kind_of? Metadata
								
		end
	
		def execute(workbranch)			
			raise 'work branch not found' unless @git_controller.branch?(workbranch)			
			@git_controller.execute(@metadata, workbranch)			
		end
		
		def submit(message)
			raise "No message provided" if message.strip.empty?	
			branch_status = @git_controller.status
			raise "Nothing to commit. You should do some work first!" if branch_status.include?("nothing to commit")
						
			@git_controller.submit(self, message)			
		end
		
		private
		def load_metadata			
			@git_controller.load_tag(metabranch_ref, metadata_name)
			@git_controller.checkout(metabranch_ref)
			@metadata = Gitabs::Metadata.new(metadata_name)
			@git_controller.checkout(task_branch)
		end
		
		def get_first_commit
			@git_controller.get_task_first_commit
			commit = @metadata.metabranch.repo.lookup(commit_hash)
		end	
		
	
	end
end
