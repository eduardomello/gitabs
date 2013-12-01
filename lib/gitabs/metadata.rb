require 'gitabs'
require 'gitabs/metadata_mapper'
require 'json'
require 'json-schema'
require 'rugged'

module Gitabs
	class Metadata
		include MetadataMapper
		attr_reader :name
		attr_reader :data
		attr_reader :metabranch
	
		def initialize(name, file=nil)
			@name = name
			@file = file	
				
			load_metabranch				
						
			if file then
				new_metadata 			
			else
				load_metadata
			end
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
			@metabranch_name = current_branch unless @metabranch_name
			@metabranch = Gitabs::Metabranch.new(@metabranch_name)			
			raise "Provided branch is not a metabranch" unless @metabranch.schema
		end
		
		def new_metadata
			valid_schema?	
			insert_metadata
			parse_data
		end
		
		def load_metadata
			raise "No metadata named '#{@name}' found" unless include_file?(@name + '.data') 
			@file = @metabranch.repo.workdir + @name + ".data"
			parse_data
		end
				
		def insert_metadata
			file_path = @metabranch.repo.workdir + @name + '.data'
			FileUtils.cp(@file, file_path)			
			@file = file_path
			commit_metadata
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
