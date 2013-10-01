require 'json'
require 'json/add/core'
require 'minigit'

class User < Struct.new(:name, :email); end

admin = User.new()
admin.name = "Eduardo Mello"
admin.email = "emsmello@gmai.com"
json = JSON.pretty_generate(admin)
puts json
repo = MiniGit.new()
repo.checkout 'data'

File.open(admin.class.name + '_' + admin.email, 'w') do |jsonFile|
        jsonFile.write(json)
end

