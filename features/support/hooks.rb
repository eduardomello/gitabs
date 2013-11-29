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
	#Gitabs::Metabranch.new('users-meta',@assets_path + '/json-schema/user-schema.json')
	`gitabs metabranch users-meta -f #{@assets_path}/json-schema/user-schema.json`
end

Before ('@task-meta') do
	#Gitabs::Metabranch.new('task-meta', @assets_path + '/json-schema/task-schema.json')
	#Gitabs::Metadata.new('landing-page', @assets_path + '/json/landing-page.json')
	`gitabs metabranch task-meta -f #{@assets_path}/json-schema/task-schema.json`
	`gitabs metadata landing-page -f #{@assets_path}/json/landing-page.json`
end

Before ('@execute-task') do
#	Gitabs::Metabranch.new('task-meta', @assets_path + '/json-schema/task-schema.json')
#	Gitabs::Metadata.new('landing-page', @assets_path + '/json/landing-page.json')
#	md = Gitabs::Metadata.new('landing-page')
#	md.execute('master')
	`gitabs metabranch task-meta -f #{@assets_path}/json-schema/task-schema.json`
	`gitabs metadata landing-page -f #{@assets_path}/json/landing-page.json`
	`gitabs execute landing-page -w master`
	`touch workfile`		
end
