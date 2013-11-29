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
	end
	
	after(:each) do
		Dir.chdir(@orig_directory)
		FileUtils.rmtree(@directory)
	end

	describe "#initialize" do
		before(:each) do
			Gitabs::Metabranch.new('users-meta', @assets_path + '/json-schema/user-schema.json')		
		end
		describe "add metadata" do
			it "fail for a invalid json file" do
				proc { Gitabs::Metadata.new("john-doe", @assets_path + "/json/invalid.json") }.must_raise(RuntimeError)
			end
			it "fails for a valid json file without required fields" do
				proc { Gitabs::Metadata.new("john-doe", @assets_path + "/json/john-doe-required-problem.json") }.must_raise(RuntimeError)
			end
			it "fails for a json file with fields other than required by schema" do
				proc { Gitabs::Metadata.new("john-doe", @assets_path + "/json/john-doe-required-problem.json") }.must_raise(RuntimeError)
			end
			it "fails if current branch is not a metabranch" do
				system('git checkout -q master')
				proc { Gitabs::Metadata.new("jonh-doe", @assets_path + "/json/john-doe.json")}.must_raise(RuntimeError)
			end
			it "succeeds for a valid json file if its accepted by metabranch schema" do
				md = Gitabs::Metadata.new("john-doe", @assets_path + "/json/john-doe.json")
				md.data.wont_be_nil				
			end
		end		
	end
end
