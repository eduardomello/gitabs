require 'spec_helper'

describe Gitabs do

	describe "#metabranch" do	
		let(:metabranch) { Gitabs.start(["metabranch"])}		
		
		context "when parameters are not provided" do
				
				it "asks for schema parameter" do					
					$stdout.should_receive(:print).with(/.Usage:.*metabranch/)
				end
		
		end
		
	end

end
