require 'gitabs'
require 'json'

module Gitabs
	class Metabranch
	
		attr_accessor :branch
		attr_accessor :repo
		attr_accessor :name
		attr_accessor :file
		
		def initialize(name, file=nil)
			@name = name
			@file = file
			
			@repo = Rugged::Repository.new('.')					
			@branch = Rugged::Branch.lookup(@repo, @name)			
			
			if @branch == nil && file != nil && valid? then
					
				create_empty_branch(@name)				
				commit_json_schema
							
				@branch = Rugged::Branch.lookup(@repo, @name)
			end
		end
		
		def valid?
			# It should verify that the JSON schema is valid under draft 4.
            # For now, it's just validating if its a valid JSON file.
            begin        		
        		json_contents = File.read(@file)        		
                JSON.parse(json_contents)                    
            rescue                          
                return false
            end
            true
		end
		
		def size			
			(@branch.tip.tree.count - 1)
		end
		
		private 
		def create_empty_branch(name)
			#see http://stackoverflow.com/questions/19181665/git-rebase-onto-results-on-single-commit
			#for further explanation
			`git mktree </dev/null`				
			emptycommit = `git commit-tree -p master 4b825dc -m 'create metabranch' </dev/null`
			`git checkout -q -b #{name} #{emptycommit}`
		end
		
		def commit_json_schema
			Dir.mkdir('schema')
			FileUtils.cp(@file, Dir.pwd + '/schema')
			file_name = File.basename(@file)
			@file = Dir.pwd + '/schema/' + file_name
			`git add schema/#{file_name}`
			`git commit -m 'create metabranch'`	
			`git clean -f -d`
		end
	end
end
