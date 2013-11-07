require 'gitabs'
require 'thor'

class Gitabs::CLI < Thor

	desc "metabranch [name] [file]", "Test"
	def metabranch(name, file)
		#do stuff
		error "Invalid JSON file" if Gitabs::Metabranch.valid?(file)			
	end

end
