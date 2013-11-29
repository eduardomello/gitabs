require 'gitabs/metabranch_controller'
require 'json'

module Gitabs
	class Metabranch
		include MetabranchController
		attr_reader :branch
		attr_reader :repo
		attr_reader :name
		attr_reader :file
		
		def initialize(name, file=nil)
			@name = name
			@file = file
			@repo = load_repo					
			@branch = load_branch				
			
			create_new_metabranch if @branch == nil && @file && valid? 
			if @branch then
				load_file unless @file	
				checkout_if_necessary		
			end				
		end
		
		def valid?			
    		return true if schema != nil
    		false    		
		end				
		
		def schema
			begin
				checkout_if_necessary								
				@schema ||= JSON.parse(File.read(@file))
			rescue				
				return nil
			end
		end
		
		def size			
			(@branch.tip.tree.count - 1)
		end
		
		private		
		def load_file
			@file = @repo.workdir + @name + '.schema'
		end
	end
end
