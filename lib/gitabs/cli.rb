require 'gitabs'
require 'gitabs/metabranch'
require 'gitabs/metadata'
require 'thor'

class Gitabs::CLI < Thor

	desc "metabranch [name] ", "Use this command to create and edit metabranches"
	option 	:file, 
			:aliases => "f", 
			:desc => "path to json-schema file"
	option 	:size, 
			:aliases => "s", 
			:desc => "show how many metadata records this metabranch have",
			:banner => ""
			
	def metabranch(name)
				
		file = options[:file] ? File.absolute_path(options[:file]) : nil
		size = options[:size]

		treat_metabranch_options(name, file, size)
	end
	
	desc "metadata", "Use this command to add metadata in a certain metabranch"
	option 	:file,
			:aliases => "f",
			:desc => "path to json file",
			:required => true			
	def metadata(name)
		file = options[:file] ? File.absolute_path(options[:file]) : nil
				
		treat_metadata_options(name, file)
		
	end
	
	desc "execute [metadata]", "Use this command to execute some work out of a certain metadata" 
	option 	:workbranch,
			:aliases => "w",
			:desc => "work branch name",
			:required => true
	def execute(metadata)
		begin
			md = Gitabs::Metadata.new(metadata)
			md.execute(options[:workbranch])
		rescue => e
			puts e.message
		else
			puts "new task branch '#{metadata}' created"
		end			
		
	end
	
	private
	def treat_metabranch_options(name, file, size)
		
		error "ERROR: Invalid command. You can't use --file and --size options at the same time'" if file && size
		
		mb = Gitabs::Metabranch.new(name, file)
		
		if file then							
			if mb.branch then
				puts "Metabranch created"
			else
				puts "Invalid JSON-Schema"
			end			
		elsif size then			
			puts mb.size.to_s + " metadata records"						
		else			
			if mb.branch != nil then
				puts "Loaded metabranch '#{name}'"
			else
				puts "Metabranch doesn't exist"
			end
		end	
	end
	
	def treat_metadata_options(name, file)
		begin
			md = Gitabs::Metadata.new(name, file)
		rescue => e
			puts e.message
		else
			puts "Metadata created"
		end			
	end	
end
