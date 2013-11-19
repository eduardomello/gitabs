require 'gitabs'
require 'json'

module Gitabs
	class Metabranch
	
		attr_accessor :branch
		attr_accessor :repo
		attr_accessor :name
		attr_accessor :file
		
		def initialize(name, file=nil)
			@name = name
			@file = file
			
			@repo = Rugged::Repository.new('.')			
			@branch = Rugged::Branch.lookup(@repo, @name)

			if @branch == nil && file != nil && valid? then
			
				@branch = @repo.create_branch(@name) 
				
				#commit json-schema and manipulate commits
				#to have only the json-schema file on tree
				#on a single commit
				json_contents = File.read(@file)
				json_name = @file.split('/').last
				
				oid = @repo.write(json_contents, :blob)
				
				parent = Rugged::Commit.lookup(@repo, @branch.tip.oid)
				
				builder = Rugged::Tree::Builder.new
				
				builder << { :type => :blob, :name => json_name, :oid => oid, :filemode => 0100644 }
							
				author = {:email => @repo.config['user.email'], :name => @repo.config['user.name'], :time => Time.now}
								
				options = {}				
				options[:tree] = builder.write(@repo)
				options[:author] = author
				options[:message] = "Create metabranch #{@name}"
				options[:committer] = author
				options[:parents] = [ parent.oid ]
				options[:update_ref] = 'HEAD'
				
				Rugged::Commit.create(@repo, options)
				
				puts `git ls-files`
			end
		end
		
		def valid?
			# It should verify that the JSON schema is valid under draft 4.
            # For now, it's just validating if its a valid JSON file.
            begin        		
        		json_contents = File.read(@file)        		
                JSON.parse(json_contents)                    
            rescue                                
                return false
            end
            true
		end
	end
end
