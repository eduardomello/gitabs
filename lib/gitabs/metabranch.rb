require 'json'
require 'json-schema'
require 'rugged'


module Gitabs
	class Metabranch
	
		attr_accessor :name
		attr_accessor :file
		
		attr_accessor :branch
	
		def initialize(name=nil, file=nil)
			@name = name
			@file = file
			load
		end
	
		def load
			#lookup if repo exists
			branch = Rugged::Branch.lookup(Gitabs.repo, @name)
			Gitabs.repo.create_branch(@name) if branch == nil			
		end
		
		def valid?
			# It should verify that the JSON schema is valid under draft 4.
			# For now, it's just validating if its a valid JSON file. 
			begin
				JSON.parse(@file)
			rescue				
				return false
			end
			true
		end			
			
	end
end
