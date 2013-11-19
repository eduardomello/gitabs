require 'gitabs'
require 'json'

module Gitabs
	class Metabranch
	
		attr_accessor :branch
		attr_accessor :repo
		
		def initialize(name, file=nil)
			@name = name
			@file = file
			@repo = Rugged::Repository.new('.')
			
			@branch = Rugged::Branch.lookup(@repo, @name)			
			@branch = @repo.create_branch(@name) if @branch == nil			
		end
		
		def valid?
			# It should verify that the JSON schema is valid under draft 4.
            # For now, it's just validating if its a valid JSON file.
            begin
        		raise "No branch loaded" if @head == nil
                JSON.parse(@file)                    
            rescue                                
                return false
            end
            true
		end
	end
end
