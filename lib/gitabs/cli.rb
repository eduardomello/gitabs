require 'gitabs'
require 'gitabs/metabranch'
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
	
	private
	def treat_metabranch_options(name, file, size)
		
		error "ERROR: Invalid command. You can't use --file and --size options at the same time'" if file && size
		
		mb = Gitabs::Metabranch.new(name, file)
		
		if file then			
			if mb.valid? then
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
	
	
end
