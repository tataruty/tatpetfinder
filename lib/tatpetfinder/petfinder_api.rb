require 'faraday'
require 'json'


module Tatpetfinder
    class PetfinderAPI 
        BASE_URL = "https://api.petfinder.com"
        attr_reader :token, :adapter

        def is_valid(token)
            return !token.empty?
        end

        def initialize(token:, adapter: Faraday.default_adapter)
            raise StandardError.new('empty token, exiting!') if !is_valid(token)
            @token = token
            @adapter = adapter
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
            connection.get("/v2/animals/#{id}").body
        end

        def types
            a = []
            body_types = connection.get('/v2/types').body['types']
            body_types.each {|p|  a << p['name']}
            JSON.generate(a)
        end

        def by_type(type)
            response = connection.get('/v2/animals') do |req|
                req.params['type'] = type
              end
              response.body
        end

        def inspect
            "#<Tatpetfinder::PetfinderAPI>"
        end
    end
end