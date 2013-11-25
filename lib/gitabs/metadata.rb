require 'gitabs'
require 'json'
require 'json-schema'

module Gitabs
	class Metadata
	
		attr_reader :name
		attr_reader :data
		attr_reader :metabranch
	
		def initialize(name, file=nil)
			@name = name
			@file = file	
			
			load_current_branch						
			
			if file then			
				valid_schema?	
				insert_metadata
				parse_data
			else
				raise "No metadata named '#{@name}' found" unless `git ls-files`.include?(name + '.data') 
				@file = @metabranch.repo.workdir + name + ".data"
				parse_data
			end
			
			
			
		end
		
		def execute(workbranch)
			load_current_branch
			raise 'work branch not found' unless `git branch`.include?(workbranch)
			
			`git mktree </dev/null`				
			emptycommit = `git commit-tree -p HEAD -p #{workbranch} #{workbranch}^{tree} -m 'create #{@name}'`
			`git checkout -b #{@name} #{emptycommit}`
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
		def load_current_branch
			repo = Rugged::Repository.new('.')
			current_branch = `git rev-parse --abbrev-ref HEAD`.strip 	
			@metabranch = Gitabs::Metabranch.new(current_branch)
			raise "Current branch is not a metabranch" unless @metabranch.schema
		end
		
		def insert_metadata
			file_path = Dir.pwd + '/' + @name + '.data'
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
