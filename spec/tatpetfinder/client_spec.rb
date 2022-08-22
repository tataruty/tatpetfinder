# frozen_string_literal: true
require('spec_helper')
require('./lib/tatpetfinder')


RSpec.describe(::Tatpetfinder::Client) do
    let(:client_id) { 'test' }
    let(:count_per_page) {3}
    let(:client_secret) { 'client_secret' }
    let(:access_token) { 'real-test-token' }
    let(:pets_file) { 'spec/fixtures/petfinder_response.json' }
    let(:expected_petfinder_body) { File.read(pets_file) }
    let(:token_response) do
        {   access_token: "real-test-token",
            scope: "read:summary",
            expires_in: 86400,
            token_type: "Bearer"
          }.to_json
      end
  
    describe('#initialize happy path') do
        subject(:client) { described_class.new(client_id: client_id, client_secret: client_secret, count_per_page: count_per_page) }

      before do
        stub_request(:post, "https://api.petfinder.com/v2/oauth2/token").
         with(
           body: "{\"client_id\":\"test\",\"client_secret\":\"client_secret\",\"grant_type\":\"client_credentials\"}",
           headers: {
       	  'Content-Type'=>'application/json',
           }).to_return(status: 200, body: token_response, headers: {'Content-Type'=>'application/json'})

           stub_request(:get, "https://api.petfinder.com/v2/animals/?limit=3").
           with(
             headers: {
               'Authorization'=>'Bearer real-test-token',
               'Content-Type'=>'application/x-www-form-urlencoded',
             }).
             to_return(status: 200, body: expected_petfinder_body, headers: {'Content-Type'=>'application/json'})
      end

      it('init happy path') do
        pets = client.all_pets
        expect(pets).not_to be_empty
        expect(pets.dig(1,'breeds','primary')).to eq("Morgan")
        expect(pets.length()).to eq(3)
      end

      it('inspect client') do
        expect(client.inspect).to eq("#<Tatpetfinder::Client>")
      end
  end

  let(:nil_token_response) do
    {   access_token: nil,
        scope: "read:summary",
        expires_in: 86400,
        token_type: "Bearer"
      }.to_json
  end

  describe('#negative tests') do
    subject(:client) { described_class.new(client_id: client_id, client_secret: client_secret, count_per_page: count_per_page) }

    before do
        stub_request(:post, "https://api.petfinder.com/v2/oauth2/token").
        with(
          body: "{\"client_id\":\"test\",\"client_secret\":\"client_secret\",\"grant_type\":\"client_credentials\"}",
          headers: {
            'Content-Type'=>'application/json',
          }).to_return(status: 200, body: nil_token_response, headers: {'Content-Type'=>'application/json'})
    end

    describe('#initialize bad input') do
        it { expect { described_class.new(client_id: client_id, client_secret: client_secret, count_per_page: count_per_page) }.to raise_error(StandardError,"nil token, exiting!") }
    end 
end
end 
  