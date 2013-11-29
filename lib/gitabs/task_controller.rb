module Gitabs
	module TaskController
		include GitController
		
		private
		def checkout(branch)
			`git checkout -q #{branch}`
		end
		
		def is_branch?(branch)
			`git branch`.include?(branch)
		end
		
		def status
			`git status`
		end
		
		def is_repo?
			begin
				load_repo
			rescue
				return false
			end
			true
		end
		
		def load_tag			
			taskbranch = current_branch		
			tag = `git describe --tags --abbrev=0 #{taskbranch}`.strip			
			raise "Not on a task branch" if !tag || tag.include?("No tags") || tag.include?("No names found")
			tag
		end
		
		def split_tag
			tag = load_tag			
			raise "Not on a task branch." if !tag || tag.include?("No names found")
			tag_split = tag.split('.')
		end
		
		def tag_metabranch
			tag_split = split_tag
			tag_split[0]			
		end
		
		def tag_metadata
			tag_split = split_tag
			tag_split[1]
		end
		
		def get_tagged_commit			
			tag = load_tag		
			commit_hash = `git show #{tag} --format=%H`.strip
		end
		
		def get_first_commit
			commit_hash = get_tagged_commit
			commit = @metadata.metabranch.repo.lookup(commit_hash)
		end
		
		def create_taskbranch(taskbranch)
			`git mktree </dev/null`				
			emptycommit = `git commit-tree -p HEAD -p #{taskbranch} #{taskbranch}^{tree} -m 'create task branch for #{@metadata.metabranch.name}.#{@metadata.name}'`
			`git checkout -q -b #{@metadata.name} #{emptycommit}`
			`git tag #{@metadata.metabranch.name}.#{@metadata.name}`
		end
			
		def commit_task(message)			
			commit = get_first_commit
			tag = load_tag
			taskbranch = current_branch
			workbranch = ''
			metabranch = ''
			commit.parents.each do |c|				
				branch = `git branch --contains #{c.oid}`.gsub(/\n|\*|#{Regexp.escape(taskbranch)}/,'').strip
				if Gitabs::Metabranch.new(branch).schema then
					metabranch = branch 			
				else
					workbranch = branch
				end
			end
			
			`git add .`
			`git commit -m '#{message}'`
			`git checkout -q #{workbranch}`
			`git merge #{taskbranch}`
			`git checkout -q #{taskbranch}`
			forgedcommit = `git commit-tree  -p #{metabranch} -p #{workbranch} #{metabranch}^{tree} -m '#{message}'`
			`git update-ref -m '#{message}' refs/heads/#{metabranch} #{forgedcommit}`
			`git checkout -q #{workbranch}`
			`git branch -D #{taskbranch}`
			`git tag -d #{tag}`
		end
	end
end
