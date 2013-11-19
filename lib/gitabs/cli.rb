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
		
		error "ERROR: Invalid command. You can't use --file and --size options at the same time'" if options[:file] && options[:size] 
		
		if options[:file] then
			puts Dir.pwd
			
			mb = Gitabs::Metabranch.new(name, options[:file])
			error "Invalid JSON-Schema" unless mb.valid?
			puts "Metabranch created"
		elsif options[:size] then
			puts "0 metadata records"			
		else
			mb = Gitabs::Metabranch.new(name)
			if mb.branch != nil then
				puts "Loaded metabranch '#{name}'"
			else
				puts "Metabranch doesn't exist"
			end
		end	
	end
	
end
