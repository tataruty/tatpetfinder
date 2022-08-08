require 'faraday'


module Tatpetfinder
    class TokenAPI 
        BASE_URL = "https://api.petfinder.com/"

        attr_reader :client_id, :client_secret, :adapter

        def is_not_valid(client_id, client_secret)
            return client_id.empty? || client_secret.empty?
        end

        def initialize(client_id:, client_secret:, adapter: Faraday.default_adapter)
            raise StandardError.new('wrong input data, exiting!') if is_not_valid(client_id, client_secret)
            @client_id = client_id
            @client_secret = client_secret   
            @grant_type = "client_credentials"
            @adapter = adapter
        end
        
        private def form_data
            {
                client_id: @client_id,
                client_secret: @client_secret,
                grant_type: @grant_type
            }
          end

        def connection
            @connection ||= Faraday.new(
                url: BASE_URL
              ) do |conn|
                conn.response :json
                conn.request :json
                conn.adapter adapter
              end 
        end 

        def post 
            connection.post('/v2/oauth2/token') do |req|
                req.body = form_data
              end
        end

        def token
            response = post
            if response.status == 200 
                response.body['access_token']
            else
                puts "Could not get token, got status: #{response.status}"
            end 
        end

        def inspect
            "#<Tatpetfinder::TokenAPI>"
        end
    end
end