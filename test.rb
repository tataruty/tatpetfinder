require "bundler/setup"
require "tatpetfinder"


if ARGV.length < 2
    puts "Too few arguments"
    exit
  end
   
  client_id= ARGV[0]
client_secret= ARGV[1]
count_per_page = ARGV[2]

@client = Tatpetfinder::Client.new(client_id: client_id, client_secret: client_secret,count_per_page: count_per_page)
puts "Pet by ID:"
puts @client.pet_by_id("56611771")
puts "##########################################################################"

puts "All PETs:"
puts @client.all_pets
puts "##########################################################################"

puts "Pet TYPEs:"
puts @client.pet_types
puts "##########################################################################"

puts "Pet by TYPE:"
puts @client.pet_by_type("Barnyard")



# @client2 = Tatpetfinder::TokenAPI.new(client_id: client_id, client_secret: client_secret)
# puts @client2.token
