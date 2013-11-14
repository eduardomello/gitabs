require 'gitabs'
require 'thor'

class Gitabs::CLI < Thor

	desc "metabranch [name] [file]", "Test"
	def metabranch(name, file)
		#do stuff
		mb = Gitabs::Metabranch.new(name, file)
		error "Invalid JSON file" unless mb.valid?			
	end

end
