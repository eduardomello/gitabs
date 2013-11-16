require 'spec_helper'
require 'gitabs'
require 'gitabs/metabranch'

def stamp
  @stamp ||= Time.new(2013, 11, 12)
end


describe Gitabs::Metabranch do

	before do
		FakeFS.activate!
		FakeFS::FileSystem.clear
	end
	
	after do
		FakeFS.deactivate!
		FakeFS::FileSystem.clear
	end
	
	it "should create a branch given no branch existed" do
		repo = Object.new
		branch = Object.new
		Gitabs.repo = repo
		
		mock(repo).lookup("some-branch") { nil }
		mock(repo).lookup("") { nil }
		mock(repo).create_branch("some-branch")	{ branch }	
		mock(branch).target { "" }
								
		metabranch = Gitabs::Metabranch.new("some-branch", "assets/json-schema/user-schema.json")
	end
	
	it "should have an empty tree as the first commit" do
		repo = Object.new
		branch = Object.new
		commit
		Gitabs.repo = repo
		
		mock(repo).lookup("some-branch") { nil }
		mock(repo).lookup("") { tree }
		mock(repo).create_branch("some-branch")	{ branch }	
		mock(branch).target { "" }
		stub(tree).count { 0 }
		
		metabranch = Gitabs::Metabranch.new("some-branch", "assets/json-schema/user-schema.json")
		metabranch.head.count.must_equal 0
	end
	
#	it "should commit json-schema if branch is empty" do
#		
#		repo = Object.new		
#		Gitabs.repo = repo
#		
#		index = Rugged::Index.new
#		
#		buffer = File.read("assets/json-schema/user-schema.json")
#		json_schema = File.new("some-branch-schema.json","w+") { |file| file.write(buffer) }
#				
#		
#		assert File.exists?("some-branch-schema.json")
#					
#		mock(Time).now { stamp }
#		mock(repo).write(buffer, :blob) { "5acfb1d4bea106d5447d133078417a23c36e98d6" }
#		mock(index).add(:path => "some-branch-schema.json", :oid => "5acfb1d4bea106d5447d133078417a23c36e98d6", :mode => 0100644) 
#		mock(index).write_tree(repo) { "76ff87af26a60d0761fc161123cf1b3118355f1f"}
#		mock(Rugged::Commit).create(repo, 
#										{ 
#											:tree => "76ff87af26a60d0761fc161123cf1b3118355f1f",
#											:author => { :email => "test@gitabs.com", :name => 'Gitabs tester', :time => stamp },
#											:commiter => { :email => "test@gitabs.com", :name => 'Gitabs tester', :time => stamp },
#											:message => "Test commit",
#											:parents => "fe24932885ed59d66239913fd8d0523af914b38b",
#											:update_ref => 'HEAD'
#										})	{ "fe24932885ed59d66239913fd8d0523af914b38b" }
#		
#		
#		# test add to stage and commit		
##		oid = repo.write("This is a blob.", :blob)
##		index = Rugged::Index.new
##		index.add(:path => "README.md", :oid => oid, :mode => 0100644)

##		options = {}
##		options[:tree] = index.write_tree(repo)

##		options[:author] = { :email => "testuser@github.com", :name => 'Test Author', :time => Time.now }
##		options[:committer] = { :email => "testuser@github.com", :name => 'Test Author', :time => Time.now }
##		options[:message] ||= "Making a commit via Rugged!"
##		options[:parents] = repo.empty? ? [] : [ repo.head.target ].compact
##		options[:update_ref] = 'HEAD'

##		Rugged::Commit.create(repo, options)


#	end
end
