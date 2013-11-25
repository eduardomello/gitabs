require 'spec_helper'
require 'tmpdir'
require 'gitabs/cli'

describe Gitabs::CLI do
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
	
	describe "#metadata" do
		describe "with 0 arguments" do
			it "outputs a error message" do
				output = capture_io { Gitabs::CLI.start(["metadata"]) }.join ''
				output.must_match /.*No value provided for required options*./
			end
		end
		describe "with file argument" do
			it "creates a metadata on current branch if valid file" do
				capture_io { Gitabs::CLI.start(["metabranch", "users-meta", "-f", @assets_path + '/json-schema/user-schema.json']) }
				output = capture_io { Gitabs::CLI.start(["metadata", "john-doe", "-f", @assets_path + "/json/john-doe.json"])}.join ''
				output.must_match /.*Metadata created*./
			end
			it "fails for a invalid json file" do
				capture_io { Gitabs::CLI.start(["metabranch", "users-meta", "-f", @assets_path + '/json-schema/user-schema.json']) }
				output = capture_io { Gitabs::CLI.start(["metadata", "john-doe", "-f", @assets_path + "/json/invalid.json"])}.join ''
				output.must_match /.*Invalid JSON*./
			end
			it "fails for invalid file for metabranch schema with more fields" do
				capture_io { Gitabs::CLI.start(["metabranch", "users-meta", "-f", @assets_path + '/json-schema/user-schema.json']) }
				output = capture_io { Gitabs::CLI.start(["metadata", "john-doe", "-f", @assets_path + "/json/john-doe-more-fields.json"])}.join ''
				output.must_match /.*JSON file not accepted on this metabranch*./
			end
			it "fails for invalid file for metabranch schema missing required fields" do
				capture_io { Gitabs::CLI.start(["metabranch", "users-meta", "-f", @assets_path + '/json-schema/user-schema.json']) }
				output = capture_io { Gitabs::CLI.start(["metadata", "john-doe", "-f", @assets_path + "/json/john-doe-required-problem.json"])}.join ''
				output.must_match /.*JSON file not accepted on this metabranch*./
			end
			it "fails if current branch is not a metabranch" do
				output = capture_io { Gitabs::CLI.start(["metadata", "john-doe", "-f", @assets_path + "/json/john-doe-require-problem.json"])}.join ''
				output.must_match /.*Current branch is not a metabranch*./
			end
		end
	end

	describe "#metabranch" do		
		describe "with 0 arguments" do
			it "output a error message" do
				output = capture_io { Gitabs::CLI.start(["metabranch"]) }.join ''
				output.must_match /.*ERROR*./
			end
		end
		describe "with 1 argument" do
			it "load metabranch if it exists" do
				capture_io { Gitabs::CLI.start(["metabranch", "users-meta", "-f", @assets_path + '/json-schema/user-schema.json']) }
				output = capture_io { Gitabs::CLI.start(["metabranch", "users-meta"]) }.join ''
				output.must_match /.*Loaded metabranch 'users-meta'*./
			end
			
			it "fails if no metabranch exists" do
				output = capture_io { Gitabs::CLI.start(["metabranch", "users-meta"]) }.join ''
				output.must_match /.*Metabranch doesn't exist*./
			end
		end
		describe "with options" do
			
			it "creates a metabranch with --file" do
				output = capture_io { Gitabs::CLI.start(["metabranch","users-meta","-f",@assets_path + "/json-schema/user-schema.json"]) }.join ''
				output.must_match /.*Metabranch created*./			
			end	
			
			it "shows metabranch size with --size" do
				capture_io { Gitabs::CLI.start(["metabranch", "users-meta", "-f", @assets_path + '/json-schema/user-schema.json']) }
				output = capture_io { Gitabs::CLI.start(["metabranch","users-meta","-s"]) }.join ''
				output.must_match /.*0 metadata records*./
			end
			
			it "fails with --file and --size options" do				
				output = capture_io { Gitabs::CLI.start(["metabranch","users-meta","-f",@assets_path + "/json-schema/user-schema.json", "-s"]) }.join ''
				output.must_match /.*ERROR*./
			end	
			
			it "fails with invalid json-schema file as --file option" do
				output = capture_io { Gitabs::CLI.start(["metabranch","users-meta","-f",@assets_path + "/json/invalid.json", "-s"]) }.join ''
				output.must_match /.*Invalid JSON-Schema*./
			end	
		end
		
		
	end
end

