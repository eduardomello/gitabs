require 'gitabs/git_mapper'
module Gitabs
	module MetadataMapper
		include GitMapper
		
		private
		def commit_metadata
			`git add #{@name}.data`
			`git commit -m 'add metadata #{@name}'`	
		end		
		
		def include_file?(file)
			`git ls-files`.include?(file)
		end
						
	end
end
