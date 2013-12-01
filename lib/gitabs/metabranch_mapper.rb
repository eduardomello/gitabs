require 'gitabs/git_mapper'
module Gitabs
	module MetabranchMapper
		include GitMapper
		
		private
		def load_branch
			Rugged::Branch.lookup(@repo, @name)
		end
		
		def checkout_if_necessary
			`git checkout -q #{@name}` if `git rev-parse --abbrev-ref HEAD`.strip != @name && @branch
		end
		
		def create_new_metabranch
			create_empty_branch
			commit_json_schema
						
			@branch = Rugged::Branch.lookup(@repo, @name)
			
		end
		
		def create_empty_branch
			#see http://stackoverflow.com/questions/19181665/git-rebase-onto-results-on-single-commit
			#for further explanation
			`git mktree </dev/null`				
			emptycommit = `git commit-tree -p master 4b825dc -m 'create metabranch' </dev/null`
			`git checkout -q --orphan #{@name} #{emptycommit}`
		end
		
		def commit_json_schema
			file_path = Dir.pwd + '/' + @name + '.schema'
			FileUtils.cp(@file, file_path)			
			@file = file_path
			`git add #{@name}.schema`
			`git commit -m 'define metabranch schema'`	
			`git clean -f -d`
		end
		
	end
end
