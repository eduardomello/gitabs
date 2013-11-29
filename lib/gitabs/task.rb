require 'gitabs'
require 'gitabs/task_controller'
require 'rugged'

module Gitabs
	class Task	
		include TaskController
		attr_reader :metadata
		
		def initialize(metadata=nil)	
			
			raise "No repository found" unless is_repo? 
			if metadata then
				@metadata = metadata
			else
				load_metadata
			end
			raise "Invalid metadata" unless @metadata.is_a?(Gitabs::Metadata) && @metadata.data
								
		end
	
		def execute(workbranch)			
			raise 'work branch not found' unless is_branch?(workbranch)			
			create_taskbranch(workbranch)			
		end
		
		def submit(message)
			raise "No message provided" if message.strip.empty?	
			branch_status = status
			raise "Nothing to commit. You should do some work first!" if branch_status.include?("nothing to commit")						
			commit_task(message)			
		end
		
		private
		def load_metadata			
			taskbranch_ref = current_branch	
			metabranch_ref = tag_metabranch
			metadata_name = tag_metadata				
			checkout(metabranch_ref)
			@metadata = Gitabs::Metadata.new(metadata_name)			
			checkout(taskbranch_ref)
		end		
	end
end
