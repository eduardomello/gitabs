require 'spec_helper'
require 'tmpdir'
require 'gitabs/metabranch'
require 'rugged'

describe Gitabs::Metabranch do
	
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
		
		describe "try to load a metabranch" do
			it "should have one argument" do
				mb = Gitabs::Metabranch.new('some-branch')
			end
			
			it "should load branch if metabranch exists" do
				Gitabs::Metabranch.new('some-branch', @assets_path + '/json-schema/user-schema.json')							
				mb = Gitabs::Metabranch.new('some-branch')
				mb.branch.must_be_instance_of Rugged::Branch
				mb.branch.name.must_match /.*some-branch*./
			end
			
			it "should fail if metabranch doesn't exists" do
				mb = Gitabs::Metabranch.new('some-branch')
				mb.branch.must_be_nil 
			end
		end
		
		
		describe "a new metabranch is created" do
		
			it "should have two valid arguments" do
				mb = Gitabs::Metabranch.new('some-branch', @assets_path + '/json-schema/user-schema.json')
				mb.name.wont_be_nil
				mb.file.wont_be_nil
			end
			
			it "should have a valid json-schema file" do
				mb = Gitabs::Metabranch.new('some-branch', @assets_path + '/json/invalid.json')
				mb.valid?.must_equal false
			end
			
			it "should have a single commit" do
				mb = Gitabs::Metabranch.new('some-branch', @assets_path + '/json-schema/user-schema.json')
				walker = Rugged::Walker.new(mb.repo)
				walker.push(mb.branch.tip.oid)
				walker.hide(mb.branch.tip.parents[0].oid)
				walker.count.must_equal 1
			end
			
			it "should have its json-schema file on head commit" do
				mb = Gitabs::Metabranch.new('some-branch', @assets_path + '/json-schema/user-schema.json')
				head = mb.branch.tip						
				head.tree.first[:name].must_match /.*user-schema.json*./
			end
			
			it "should have a single file on head commit" do
				mb = Gitabs::Metabranch.new('some-branch', @assets_path + '/json-schema/user-schema.json')
				head = mb.branch.tip				
				head.tree.count.must_equal 1
			end
		end
	end
	
	describe "#size" do
	
		it "should return metadata total" do
			mb = Gitabs::Metabranch.new('some-branch', @assets_path + '/json-schema/user-schema.json')
			head = mb.branch.tip				
			head.tree.count.must_equal 1
		end
	end
end


