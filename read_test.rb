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

repo = MiniGit.new()
repo.checkout('a985153')

oldJson = File.read('User_emsmello@gmail.com')


data = JSON.parse(oldJson)



admin = data.map {|u| User.new(u["name"], u"[email]")}

puts admin.name

repo.checkout('json-tests')
