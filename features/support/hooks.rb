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
	Dir.chdir(@orig_directory)
end

After do	
	FileUtils.rmtree(@directory)
end

Before ('@one-metabranch') do 
	Gitabs::Metabranch.new('some-branch',@assets_path + '/json-schema/user-schema.json')
end
