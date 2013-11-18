require 'gitabs/cli'
require 'rugged'

module Gitabs
	def self.repository
		@repository ||= Rugged::Repository.new('.')
	end
end
