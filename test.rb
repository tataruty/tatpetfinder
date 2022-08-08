require "bundler/setup"
require "tatpetfinder"


if ARGV.length < 2
    puts "Too few arguments"
    exit
  end
   
  client_id= ARGV[0]
client_secret= ARGV[1]

@client = Tatpetfinder::Client.new(client_id: client_id, client_secret: client_secret)
puts JSON.pretty_generate(@client.pet_by_id("56573024"))
puts JSON.pretty_generate(@client.all_pets)

puts @client.pet_types
# puts @client.pet_by_type("bird")



# @client2 = Tatpetfinder::TokenAPI.new(client_id: client_id, client_secret: client_secret)
# puts @client2.token
