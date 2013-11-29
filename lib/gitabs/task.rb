require 'gitabs'
require 'rugged'

module Gitabs
	class Task	
		attr_reader :metadata
		
		def initialize(metadata=nil)
			
			Rugged::Repository.new('.') #this raise RepositoryError if not on a repo
			unless metadata then				
				task_branch = `git rev-parse --abbrev-ref HEAD`.strip
				tag = `git describe --tags --abbrev=0 #{task_branch}`.strip				
				raise "Not on a task branch." if tag.include?("No names found")
				tag_split = tag.split('.')
				metabranch_ref 	= tag_split[0]
				metadata_name 	= tag_split[1]
				`git checkout -q #{metabranch_ref}`
				metadata = Gitabs::Metadata.new(metadata_name)
				puts task_branch
				`git checkout -q #{task_branch}`
			end
			raise "Invalid metadata" unless metadata.kind_of? Metadata
			@metadata = metadata
			
		end
	
		def execute(workbranch)
			
			raise 'work branch not found' unless `git branch`.include?(workbranch)
			
			`git mktree </dev/null`				
			emptycommit = `git commit-tree -p HEAD -p #{workbranch} #{workbranch}^{tree} -m 'create task branch for #{@metadata.metabranch.name}.#{@metadata.name}'`
			`git checkout -q -b #{@metadata.name} #{emptycommit}`
			`git tag #{@metadata.metabranch.name}.#{@metadata.name}`
			
		end
		
		def submit(message)
			raise "No message provided" if message.strip.empty?	
			branch_status = `git status`
			puts `git branch`
			raise "Nothing to commit. You should do some work first!" if branch_status.include?("nothing to commit")
			
			task_branch = `git rev-parse --abbrev-ref HEAD`.strip
			tag = `git describe --tags --abbrev=0 #{task_branch}`.strip			
			commit_hash = `git show #{tag} --format=%H`.strip
			commit = @metadata.metabranch.repo.lookup(commit_hash)
			
			workbranch = ''
			metabranch = ''
			commit.parents.each do |c|				
				branch = `git branch --contains #{c.oid}`.gsub(/\n|\*|#{Regexp.escape(task_branch)}/,'').strip
				
				if Gitabs::Metabranch.new(branch).schema then
					metabranch = branch 			
				else
					workbranch = branch
				end
			end
			
			`git add .`
			`git commit -m '#{message}'`
			`git checkout -q #{workbranch}`
			`git merge #{task_branch}`
			`git checkout -q #{task_branch}`

			forgedcommit = `git commit-tree  -p #{metabranch} -p #{workbranch} #{metabranch}^{tree} -m '#{message}'`
			`git update-ref -m '#{message}' refs/heads/#{metabranch} #{forgedcommit}`
			`git checkout -q #{workbranch}`
			`git branch -D #{task_branch}`
			
		end
	
	end
end
