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
	
	@assets_path = File.expand_path('../../../assets/', __FILE__)
	
end

After do
	Dir.chdir(@orig_directory)
	FileUtils.rmtree(@directory)
end

Before ('@one-metabranch') do 
	`gitabs metabranch users-meta -f #{@assets_path}/json-schema/user-schema.json`
end

Before ('@task-meta') do
	`gitabs metabranch task-meta -f #{@assets_path}/json-schema/task-schema.json`
	`gitabs metadata landing-page -f #{@assets_path}/json/landing-page.json`
end

Before ('@execute-task') do
	`gitabs metabranch task-meta -f #{@assets_path}/json-schema/task-schema.json`
	`gitabs metadata landing-page -f #{@assets_path}/json/landing-page.json`
	`gitabs execute landing-page -w master`
end

Before ('@ready-to-submit') do
	`gitabs metabranch task-meta -f #{@assets_path}/json-schema/task-schema.json`
	`gitabs metadata landing-page -f #{@assets_path}/json/landing-page.json`
	`gitabs execute landing-page -w master`
	`touch taskfile`
end
