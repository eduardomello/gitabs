require 'spec_helper'
require 'tmpdir'
require 'gitabs/metabranch'
require 'rugged'

describe Gitabs::Metabranch do
	describe "#initialize" do
		before(:each) do
			@directory = Dir.mktmpdir('temp-repo')
			@orig_directory = Dir.pwd
			Dir.chdir(@directory)
			capture_io {
				`git init`
				`touch dummy`
				`git add .`
				`git commit -m 'dummy commit'`		
			}
		end
		after(:each) do
			Dir.chdir(@orig_directory)
			FileUtils.rmtree(@directory)
		end
		it "should load a branch if one argument is provided" do
			mb = Gitabs::Metabranch.new('some-branch')
			mb.branch.must_be_instance_of Rugged::Branch
		end
	end
end


