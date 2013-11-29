require 'gitabs'
require 'gitabs/git_controller'
require 'rugged'

module Gitabs
	class Task	
		include GitController
		attr_reader :metadata
		
		def initialize(metadata=nil)	
			
			raise "No repository found" unless is_repo? 
			if metadata then
				@metadata = metadata
			else
				load_metadata
			end
			raise "Invalid metadata" unless metadata.kind_of? Metadata
								
		end
	
		def execute(workbranch)			
			raise 'work branch not found' unless is_branch?(workbranch)			
			create_workbranch(workbranch)			
		end
		
		def submit(message)
			raise "No message provided" if message.strip.empty?	
			branch_status = status
			raise "Nothing to commit. You should do some work first!" if branch_status.include?("nothing to commit")
						
			commit_task(message)			
		end
		
		private
		def load_metadata			
			load_tag(metabranch_ref, metadata_name)
			checkout(metabranch_ref)
			@metadata = Gitabs::Metadata.new(metadata_name)
			checkout(task_branch)
		end		
	end
end
