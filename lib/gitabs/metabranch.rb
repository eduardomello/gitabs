require 'json'
require 'json-schema'


module Gitabs
	class Metabranch
	
			def self.valid?(file)
				# It should verify that the JSON schema is valid under draft 4.
				# For now, it's just validating if its a valid JSON file. 
				begin
					JSON.parse(file)
				rescue				
					false
				end
				true
			end	
	end
end
