require 'spec_helper'
require 'gitabs/metadata'

describe Gitabs::Metadata do

	before(:each) do
		@assets_path = File.expand_path('../../../assets/', __FILE__)

		@directory = Dir.mktmpdir('temp-repo')
		@orig_directory = Dir.pwd
		Dir.chdir(@directory)
		capture_io {
			`git init`
			`touch dummy`
			`git add .`
			`git commit -m 'dummy commit'`
			`touch foo`
			`git add .`
			`git commit -m 'foo commit'`	
		}						
		Gitabs::Metabranch.new('users-meta', @assets_path + '/json-schema/user-schema.json')							
	end
	
	after(:each) do
		Dir.chdir(@orig_directory)
		FileUtils.rmtree(@directory)
	end

	describe "#initialize" do
		describe "add metadata" do
			it "fail for a invalid json file" do
				md = Gitabs::Metadata.new(@assets_path + "/json/invalid.json")
				md.data.must_be_nil
			end
			it "fails for a valid json file without required fields" do
				md = Gitabs::Metadata.new(@assets_path + "/json/john-doe-required-problem.json")
				md.data.must_be_nil
			end
			it "fails for a json file with fields other than required by schema" do
				md = Gitabs::Metadata.new(@assets_path + "/json/john-doe-required-problem.json")
				md.data.must_be_nil
			end
			it "succeeds for a valid json file if its accepted by metabranch schema" do
				md = Gitabs::Metadata.new(@assets_path + "/json/john-doe.json")
				md.data.wont_be_nil				
			end
		end
	end

end
