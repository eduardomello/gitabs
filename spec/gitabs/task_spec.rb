require 'spec_helper'
require 'gitabs/task'
require 'rugged'

describe Gitabs::Task do

	before(:each) do
		@assets_path = File.expand_path('../../../assets/', __FILE__)

		@directory = Dir.mktmpdir('temp-repo')
		@orig_directory = Dir.pwd
		Dir.chdir(@directory)					
	end

	describe "#initialize" do
		describe "failure situations" do			
			it "should be on a repository" do
				proc { Gitabs::Task.new(nil) }.must_raise(RuntimeError)
			end				
			it "should fail with invalid metadata" do
				capture_io {
					`git init`
					`touch dummy`
					`git add .`
					`git commit -m 'dummy commit'`
					`touch foo`
					`git add .`
					`git commit -m 'foo commit'`	
				}
				proc { Gitabs::Task.new('wrong')}.must_raise(RuntimeError)
			end									
		end		
		describe "successful load situations" do
			it "should load if no metadata is provided" do
				capture_io {
					`git init`
					`touch dummy`
					`git add .`
					`git commit -m 'dummy commit'`
					`touch foo`
					`git add .`
					`git commit -m 'foo commit'`	
				}
				Gitabs::Metabranch.new('task-meta', @assets_path + '/json-schema/task-schema.json')
				md = Gitabs::Metadata.new("landing-page", @assets_path + "/json/landing-page.json")
				Gitabs::Task.new(md).execute('master')
				
				task = Gitabs::Task.new
				task.metadata.name.must_match "landing-page"
			end
		end
	end
	describe "#execute" do
		before(:each) do
			capture_io {
				`git init`
				`touch dummy`
				`git add .`
				`git commit -m 'dummy commit'`
				`touch foo`
				`git add .`
				`git commit -m 'foo commit'`	
			}
			Gitabs::Metabranch.new('task-meta', @assets_path + '/json-schema/task-schema.json')
		end
		it "fails if work branch doesn't exist" do			
			md = Gitabs::Metadata.new("landing-page", @assets_path + "/json/landing-page.json")
			task = Gitabs::Task.new(md)
			proc { task.execute('void_branch')}.must_raise(RuntimeError)
		end
	
		
		describe "succeeds if work branch exists" do
			let(:md) { Gitabs::Metadata.new("landing-page", @assets_path + "/json/landing-page.json") }
			let(:task) { Gitabs::Task.new(md) }
			before(:each) do
				task.execute('master')
			end
			
			it "should create a branch after the metadata" do
				output = capture_subprocess_io { system('git rev-parse --abbrev-ref HEAD')}.join ''
				output.must_match 'landing-page'
			end
		

			it "should have the metabranch as parent" do
				parent_list 	= capture_subprocess_io { system('git rev-list --parents -n 1 HEAD')}.join ''				
				metabranch_hash	= md.metabranch.branch.tip.oid
							
				parent_list.must_match metabranch_hash
			end
			
			it "should have the work branch as parent" do
				parent_list = capture_subprocess_io { system('git rev-list --parents -n 1 HEAD')}.join ''
				master_hash = capture_subprocess_io { system('git show-ref --hash master')}.join ''
				
				parent_list.must_match master_hash
			end
			 
			it "should have the files from work branch" do
				task_files = capture_subprocess_io { system('git ls-files')}.join ''			
				system('git checkout -q master')
				master_files = capture_subprocess_io { system('git ls-files')}.join ''
				task_files.must_match master_files	
			end
			
			it "shouldn't have files from metabranch" do
				task_files = capture_subprocess_io { system('git ls-files')}.join ''			
				system('git checkout -q task-meta')
				metabranch_files = capture_subprocess_io { system('git ls-files')}.join ''
				task_files.wont_match metabranch_files
			end	
			
			it "should have a tag after metadata point to its HEAD" do
				output = capture_subprocess_io { system('git describe --tags --abbrev=0 landing-page')}.join ''
				output.must_match "task-meta.landing-page"	
			end	
			
		end
	end
	
	describe "#submit" do
		let(:md) { Gitabs::Metadata.new("landing-page", @assets_path + "/json/landing-page.json") }
		let(:task) { Gitabs::Task.new(md) }
		before(:each) do
			capture_io {
				`git init`
				`touch dummy`
				`git add .`
				`git commit -m 'dummy commit'`
				`touch foo`
				`git add .`
				`git commit -m 'foo commit'`	
			}
			Gitabs::Metabranch.new('task-meta', @assets_path + '/json-schema/task-schema.json')
			task.execute('master')
		end
		describe "failing situations" do			
			it "fails if no argument is provided" do				
			 	proc { task.submit }.must_raise(ArgumentError)
			end
			 
			 it "fails if no message is provided" do
			 	proc { task.submit('') }.must_raise(RuntimeError)
			 end
			 
			 it "should fail if nothing to stage" do
			 	proc { task.submit('finish task')}.must_raise(RuntimeError)
			 end
		end
		 
		describe "on successful submit" do
			before(:each) do			
				`touch taskfile`
		 	end
		 			 	
			it "should merge back into work branch" do
				task_files = capture_subprocess_io { system('ls')}.join ''
				task.submit('finish task')		
				`git checkout -q master`
			 	master_files = capture_subprocess_io { system('git ls-files')}.join ''
			 	master_files.must_match task_files		 			 	 	
			end
			 
			 it "metabranch should know task was submitted" do
			 	task.submit('finish task')
			 	last_commit = capture_subprocess_io { system('git log --format=%B -n 1 task-meta')}.join ''
			 	last_commit.must_match 'finish task'
			 end
			 
			 it "metabranch should keep tree of files" do
			 	task.submit('finish task')
			 	`git checkout -q task-meta`
			 	metabranch_files = capture_subprocess_io { system('git ls-files')}.join ''
			 	`git checkout -q task-meta^`
			 	metabranch_parent_files = capture_subprocess_io { system('git ls-files')}.join ''
			 	metabranch_parent_files.must_match metabranch_files
			 end
			 
			 it "task branch must be deleted" do
			 	task.submit('finish task')
			 	output = capture_subprocess_io { system('git branch')}.join ''
			 	output.wont_match 'master#task-meta#landin-page'
			 end
		end		
 	end

end
