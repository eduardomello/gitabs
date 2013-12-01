module Gitabs
	module GitMapper
		
		private
		def load_repo
			Rugged::Repository.new('.')
		end
		
		def current_branch
			`git rev-parse --abbrev-ref HEAD`.strip
		end
			
	end
end
