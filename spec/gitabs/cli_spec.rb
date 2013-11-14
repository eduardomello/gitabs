require 'spec_helper'
require 'gitabs/cli'
require 'rugged'


describe Gitabs::CLI do

	describe "#metabranch" do	
	
		describe "should verify arguments" do
			it "should ask for a argument" do
				out = capture_io{ Gitabs::CLI.start ['metabranch'] }.join ''
			    out.must_match /.*ERROR.*/
			end			
		
			it "it should ask for a second argument" do
				out = capture_io{ Gitabs::CLI.start ['metabranch', 'new-branch'] }.join ''
				out.must_match /.*ERROR.*/
			end
		
		end
		
		it "should reject invalid json files" do
			out = capture_io{ Gitabs::CLI.start ['metabranch', 'new-branch', 'assets/json/invalid.json']}.join ''
			out.must_match /.*Invalid JSON file.*/ 
		end
				
		describe "with valid json-schema file" do
			before do
				repo = Rugged::Repository.new('./')
			end
			it "should create a new branch on repository" do
				
			end
			
			it "should commit json-schema file to new branch" do
			
			end
		
		end
		
		
	end
	
end
