require 'gitabs'
require 'json'
require 'json-schema'

module Gitabs
	class Metadata
	
		attr_reader :data
		attr_reader :metabranch
	
		def initialize(file)
			@file = file	
			repo = Rugged::Repository.new('.')
			current_branch = repo.head.name.split("/").last				
			@metabranch = Gitabs::Metabranch.new(current_branch)			
			if @metabranch.schema then
				if valid_schema? then
					#insert new metadata
					FileUtils.cp(@file, Dir.pwd)
					file_name = File.basename(@file)
					@file = Dir.pwd + '/' + file_name
					`git add #{file_name}`
					`git commit -m 'add metadata #{file_name}'`	
							
					#load file
					begin
						json_contents = File.read(@file)
						@data = JSON.parse(json_contents)
					rescue
						@data = nil
					end
				end
			else
				puts 'Current branch is not a metabranch'
			end
		end
		
		def valid_json?			
    		begin        		
				json_contents = File.read(@file)        		
        		JSON.parse(json_contents)                    
    		rescue                          
        		return false
    		end
    		true
		end
		
		def valid_schema?
			if valid_json? then	
				begin
					json_contents = File.read(@file)   
	        		return JSON::Validator.validate(@metabranch.schema.to_json, json_contents)         		
	        	rescue
	        		return false
	        	end
        	end
        	false  
        end    
		
	end
end
