require 'spec_helper'
require 'tmpdir'
require 'gitabs/cli'

describe Gitabs::CLI do
	describe "#metabranch" do
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
			@assets_path = File.expand_path('../../../assets/', __FILE__)
		end
		after(:each) do
			Dir.chdir(@orig_directory)
			FileUtils.rmtree(@directory)
		end
		describe "with 0 arguments" do
			it "output a error message" do
				output = capture_io { Gitabs::CLI.start(["metabranch"]) }.join ''
				output.must_match /.*ERROR*./
			end
		end
		describe "with 1 argument" do
			it "load metabranch if it exists" do
				Gitabs::Metabranch.new('some-branch',@assets_path + '/json-schema/user-schema.json')
				output = capture_io { Gitabs::CLI.start(["metabranch", "some-branch"]) }.join ''
				output.must_match /.*Loaded metabranch 'some-branch'*./
			end
			
			it "fails if no metabranch exists" do
				output = capture_io { Gitabs::CLI.start(["metabranch", "some-branch"]) }.join ''
				output.must_match /.*Metabranch doesn't exist*./
			end
		end
		describe "with options" do
			
			it "creates a metabranch with --file" do
				output = capture_io { Gitabs::CLI.start(["metabranch","some-branch","-f",@assets_path + "/json-schema/user-schema.json"]) }.join ''
				output.must_match /.*Metabranch created*./			
			end	
			
			it "shows metabranch size with --size" do
				Gitabs::Metabranch.new("some-branch", @assets_path + "/json-schema/user-schema.json")
				output = capture_io { Gitabs::CLI.start(["metabranch","some-branch","-s"]) }.join ''
				output.must_match /.*0 metadata records*./
			end
			
			it "fails with --file and --size options" do				
				output = capture_io { Gitabs::CLI.start(["metabranch","some-branch","-f",@assets_path + "/json-schema/user-schema.json", "-s"]) }.join ''
				output.must_match /.*ERROR*./
			end	
			
			it "fails with invalid json-schema file as --file option" do
				output = capture_io { Gitabs::CLI.start(["metabranch","some-branch","-f",@assets_path + "/json/invalid.json", "-s"]) }.join ''
				output.must_match /.*Invalid JSON-Schema*./
			end	
		end
		
		
	end
end

