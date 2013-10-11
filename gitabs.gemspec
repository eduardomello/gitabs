Gem::Specification.new do |s|
  s.name        = 'gitabs'
  s.version     = '0.0.0'
  s.date        = '2013-10-11'
  s.summary     = "Gitabs is a git extension"
  s.description = "Gitabs extends your git repository to the real world"
  s.authors     = ["Eduardo Mello"]
  s.email       = 'eduardo@bonaparte.ag'
  s.files       = ["lib/gitabs.rb"]
  s.homepage    = 'http://www.github.com/eduardomello/gitabs'
	s.license     = 'MIT'
  
  s.add_runtime_dependency 'thor'
end
