module Gitabs
	def self.repo
		@repo ||= Rugged::Repository.new
	end
	
	def self.repo=(repo)
		@repo = repo
	end
end

require 'gitabs/version'
require 'gitabs/metabranch'



