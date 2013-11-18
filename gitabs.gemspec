# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gitabs/version"

Gem::Specification.new do |s|

  s.name        = 'gitabs'
  s.version     = Gitabs::VERSION
  s.date        = '2013-10-11'
  s.summary     = "Gitabs is a git extension"
  s.description = "Gitabs extends your git repository to the real world"
  s.authors     = ["Eduardo Mello"]
  s.email       = 'emsmello@gmail.com'  
  s.homepage    = 'http://www.github.com/eduardomello/gitabs'
  s.license     = 'MIT'
	
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-cucumber"
  s.add_development_dependency "rake"  

  s.add_runtime_dependency 'thor'
  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'json-schema'
  s.add_runtime_dependency 'rugged'

  
end
