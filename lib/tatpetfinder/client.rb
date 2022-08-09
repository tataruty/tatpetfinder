require 'faraday'

module Tatpetfinder
    class Client 
        def initialize(client_id:, client_secret:, count_per_page:, adapter: Faraday.default_adapter)
            if count_per_page.nil? then count_per_page = 100
            end
            @token_api = Tatpetfinder::TokenAPI.new(client_id: client_id, client_secret: client_secret)
            token = @token_api.token
            raise StandardError.new('nil token, exiting!') if token.nil?
            @petfinder_api = Tatpetfinder::PetfinderAPI.new(token: token, count_per_page: count_per_page)
        end

        def all_pets
            @petfinder_api.pets("")
        end

        def pet_by_id(id = "")
            @petfinder_api.pets(id)
        end

        def pet_types
            @petfinder_api.types
        end

        def pet_by_type(type = "")
            @petfinder_api.by_type(type)
        end

        def inspect
            "#<Tatpetfinder::Client>"
        end
    end
end