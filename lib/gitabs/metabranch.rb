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
				
				#creates a branch with an empty tree with master HEAD as parent
				#see http://stackoverflow.com/questions/19181665/git-rebase-onto-results-on-single-commit
				#for deeper explanation			
				emptytree = `git mktree </dev/null`
				emptycommit = `git commit-tree -p master #{emptytree} </dev/null`
				`git branch #{name} #{emptycommit}`				
				#copy json schema and commit it			
				FileUtils.cp(@file, Dir.pwd)
				`git add .`
				`git commit -m 'Metabranch create'`
				puts `git ls`
				
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
	end
end
