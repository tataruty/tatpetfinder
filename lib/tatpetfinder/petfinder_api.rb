require 'faraday'
require 'json'
require 'pry'


module Tatpetfinder
    class PetfinderAPI 
        BASE_URL = "https://api.petfinder.com"
        attr_reader :token, :count_per_page, :adapter

        def is_valid(token)
            return !token.empty?
        end

        def initialize(token:, count_per_page:, adapter: Faraday.default_adapter)
            raise StandardError.new('empty token, exiting!') if !is_valid(token)
            @token = token
            @adapter = adapter
            @count_per_page = count_per_page
        end

        def connection
            @connection ||= Faraday.new(
                url: BASE_URL,
                headers: {'Content-Type' => 'application/x-www-form-urlencoded'}
              ) do |conn|
                conn.response :json
                conn.request :url_encoded
                conn.request :authorization, 'Bearer', @token
                conn.adapter adapter
              end 
        end 

        def pets(id)
            if id.empty? then 
                data = connection.get("/v2/animals/") do |req|
                    req.params['limit'] = @count_per_page
                end
                return collect_data_from_array(data.body['animals'])
            else 
                data = connection.get("/v2/animals/#{id}").body['animal']
                return collect_data_from_single(data) unless data.empty?
            end
        end

        def types
            a = []
            body_types = connection.get('/v2/types').body['types']
            body_types.each {|p|  a << p['name']}
            JSON.generate(a)
        end

        def by_type(type)
            response = connection.get('/v2/animals') do |req|
                req.params['limit'] = @count_per_page
                req.params['type'] = type
              end
              body = response.body

              if body.empty? || body['animals'].nil? then
                return []
              else data = body['animals']
                puts "Found #{data.length()} anymals of #{type} type"
                if data.length() > 1 then
                    return collect_data_from_array(data)                
                elsif data.length() == 1 then
                    collect_data_from_single(data)
                else
                    return []
                end
             end
        end

        def inspect
            "#<Tatpetfinder::PetfinderAPI>"
        end

        def collect_data_from_array(data)
            animals = []
            data.each do |animal|
                animals.append(collect_data_from_single(animal))
            end
            animals
        end

        def collect_data_from_single(animal)
            animal.slice("species", "breeds", "colors", "age", "gender", "size", "coat", "attributes", "environment", "tags", "name", "description")
        end
    end 
end
