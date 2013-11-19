require 'tmpdir'

Before do		
	@dirs = ["."]
	@directory = Dir.mktmpdir('temp-repo')
	@orig_directory = Dir.pwd
	Dir.chdir(@directory)
	
	`git init`
	`touch dummy`
	`git add .`
	`git commit -m 'dummy commit'`
	
end

AfterStep do
	puts Dir.pwd
end
