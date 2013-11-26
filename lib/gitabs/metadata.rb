require 'gitabs'
require 'json'
require 'json-schema'
require 'rugged'

module Gitabs
	class Metadata
	
		attr_reader :name
		attr_reader :data
		attr_reader :metabranch
	
		def initialize(name=nil, file=nil)
			@name = name
			@file = file	
			
			load_metabranch		
			
			if name = nil then
				task_branch = `git rev-parse --abbrev-ref HEAD`.strip
				split_branch = task_branch.split('#')
				workbranch = split_branch[0]
				metabranch = split_branch[1]
				@name = split_branch[2]				
			end		
			
			if file then
				new_metadata 			
			else
				load_metadata
			end
		end
		
		def execute(workbranch)
			load_metabranch
			raise 'work branch not found' unless `git branch`.include?(workbranch)
			
			`git mktree </dev/null`				
			emptycommit = `git commit-tree -p HEAD -p #{workbranch} #{workbranch}^{tree} -m 'create #{@name}'`
			`git checkout -q -b #{workbranch}##{@metabranch.name}##{@name} #{emptycommit}`
		end
		
		def submit(message)
			raise "No message provided" if message.strip.empty?	
			branch_status = `git status`
			raise "Nothing to commit. You should do some work first!" if branch_status.include?("nothing to commit")
			
			task_branch = `git rev-parse --abbrev-ref HEAD`.strip
			split_branch = task_branch.split('#')
			workbranch = split_branch[0]
			metabranch = split_branch[1]
			
			`git add .`
			`git commit -m '#{message}'`
			`git checkout -q #{workbranch}`
			`git merge #{task_branch}`
			`git checkout -q #{task_branch}`

			forgedcommit = `git commit-tree  -p #{metabranch} -p #{workbranch} #{metabranch}^{tree} -m '#{message}'`
			`git update-ref -m '#{message}' refs/heads/#{metabranch} #{forgedcommit}`
			`git checkout -q #{workbranch}`
			`git branch -D #{task_branch}`
			git 
		end
		
				
		def valid_json?			
    		begin        		
				json_contents = File.read(@file)        		
        		JSON.parse(json_contents)                    
    		rescue                         
        		raise "Invalid JSON file"
    		end
    		true
		end
		
		def valid_schema?
			if valid_json? then	
				json_contents = File.read(@file)   
        		raise "JSON file not accepted on this metabranch" unless JSON::Validator.validate(@metabranch.schema.to_json, json_contents)         		
        		return true
	    	end
        	false  
        end    
		
		private
		def load_metabranch
			repo = Rugged::Repository.new('.')
			current_branch = `git rev-parse --abbrev-ref HEAD`.strip 	
			@metabranch = Gitabs::Metabranch.new(current_branch)
			raise "Current branch is not a metabranch" unless @metabranch.schema
		end
		
		def new_metadata
			valid_schema?	
			insert_metadata
			parse_data
		end
		
		def load_metadata
			raise "No metadata named '#{@name}' found" unless `git ls-files`.include?(name + '.data') 
			@file = @metabranch.repo.workdir + @name + ".data"
			parse_data
		end
				
		def insert_metadata
			file_path = @metabranch.repo.workdir + @name + '.data'
			FileUtils.cp(@file, file_path)			
			@file = file_path
			`git add #{@name}.data`
			`git commit -m 'add metadata #{@name}'`	
		end
		
		def parse_data
			begin
				json_contents = File.read(@file)
				@data = JSON.parse(json_contents)
			rescue
				raise "Invalid JSON file"
			end
		end
		
	end
end
