# spec_helper.rb


require 'minitest/autorun'


module Gitabs

	class RepoTest < MiniTest::Unit::TestCase
		def setup
			super
			@test_repo = Dir.mktmpdir("gitabs_test")
		end
		
		def teardown
			FileUtils.remove_entry_secure @test_repo
		end
		
		def test_init(test)
			case test
				when 'basic'
					Dir.chdir(@test_repo) do
						File.new("README.md","w+") { |file| file.write(buffer) }
						´git init | git add . | git commit -m 'Inital commit'´ 
						
					end
			end
			Rugged::Repository.new(@test_repo)
		end
		
	end

end
