require 'gitabs'
require 'json'

module Gitabs
	class Metbranch
		def valid?(name, file)
			# It should verify that the JSON schema is valid under draft 4.
            # For now, it's just validating if its a valid JSON file.
            begin
                    JSON.parse(file)
            rescue                                
                    return false
            end
            true
		end
	end
end
