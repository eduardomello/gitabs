require 'gitabs'
require 'json'

module Gitabs
	class Metabranch
		attr_accessor :head
		def initialize(name, file=nil)
			@name = name
			@file = file
						
			@head = Rugged::Commit.lookup(Gitabs.repository, @name)
			@head = Gitabs.repository.create_branch(@name) if @head == nil			
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
