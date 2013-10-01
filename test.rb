require 'json'
require 'json/add/core'

class User < Struct.new(:name, :email); end

admin = User.new()
admin.name = "Eduardo Mello"
puts JSON.pretty_generate(admin)
