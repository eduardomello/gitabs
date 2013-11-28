require 'gitabs'
require 'json'

module Gitabs
	class Metabranch
	
		attr_reader :branch
		attr_reader :repo
		attr_reader :name
		attr_reader :file
		
		def initialize(name, file=nil)
			@name = name
			@file = file
			@repo = Rugged::Repository.new('.')					
			@branch = Rugged::Branch.lookup(@repo, @name)				
			
			create_new_metabranch if @branch == nil && @file && valid? 
			if @branch then
				load_file unless @file	
				checkout_if_necessary		
			end				
		end
		
		def valid?			
    		return true if schema != nil
    		false    		
		end				
		
		def schema
			begin
				checkout_if_necessary								
				@schema ||= JSON.parse(File.read(@file))
			rescue				
				return nil
			end
		end
		
		def size			
			(@branch.tip.tree.count - 1)
		end
		
		private 
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
			`git checkout -q -b #{@name} #{emptycommit}`
		end
		
		def commit_json_schema
			file_path = Dir.pwd + '/' + @name + '.schema'
			FileUtils.cp(@file, file_path)			
			@file = file_path
			`git add #{@name}.schema`
			`git commit -m 'define metabranch schema'`	
			`git clean -f -d`
		end
		
		def load_file
			@file = @repo.workdir + @name + '.schema'
		end
	end
end
