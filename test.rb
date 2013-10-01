require 'json'
require 'json/add/core'
require 'minigit'

class Struct
  def to_map
    map = Hash.new
    self.members.each { |m| map[m] = self[m] }
    map
  end

  def to_json(*a)
    to_map.to_json(*a)
  end
end

class User < Struct.new(:name, :email); end

admin = User.new()
admin.name = "Eduardo Mello"
admin.email = "emsmello@gmai.com"
json = JSON.pretty_generate(admin)
puts json
repo = MiniGit.new()
repo.checkout 'data'

filename = admin.class.name + '_' + admin.email

File.open(filename, 'w') do |jsonFile|
        jsonFile.write(json)
end

puts repo.add(filename)
puts repo.commit(:m => filename + 'updated')

#log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short

puts repo.log({:pretty => format:'5h %ad | %s%d [%an]', :graph => true, :date => short})


repo.checkout('json-tests')

