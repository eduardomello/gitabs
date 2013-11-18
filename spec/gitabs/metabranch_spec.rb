require 'spec_helper'
require 'tmpdir'
require 'gitabs/metabranch'
require 'rugged'

describe Gitabs::Metabranch do
	describe "#initialize" do
		it "should load a branch if one argument is provided" do
			mb = Gitabs::Metabranch.new('some-branch')
			mb.head.must_be_instance_of Rugged::Commit
		end
	end
end
