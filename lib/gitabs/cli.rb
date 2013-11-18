require 'gitabs'
require 'thor'

class Gitabs::CLI < Thor

	desc "metabranch [name] [file]", "Use this command to create and edit metabranches"
	def metabranch(name, file)
		#do stuff
#		mb = Gitabs::Metabranch.new(name, file)
#		error "Invalid JSON file" unless mb.valid?			
	end

end
