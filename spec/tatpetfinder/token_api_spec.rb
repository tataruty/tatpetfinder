# frozen_string_literal: true
require('spec_helper')
require('./lib/tatpetfinder')


RSpec.describe(::Tatpetfinder::TokenAPI) do
    let(:client_id) { 'test' }
    let(:client_secret) { 'client_secret' }
    let(:grant_type) { 'client_credentials' }
    let(:access_token) { 'real-test-token' }
    let(:argument_file) { 'spec/fixtures/token.json' }
    let(:expected_body) { JSON.parse(File.read(argument_file)) }
    
    let(:login_response) do
      {   access_token: "real-test-token",
          scope: "read:summary",
          expires_in: 86400,
          token_type: "Bearer"
        }.to_json
    end
  
    describe('#initialize happy path') do
      subject(:token_api) { described_class.new(client_id: client_id, client_secret: client_secret) }

      before do
        stub_request(:post, "https://api.petfinder.com/v2/oauth2/token").
         with(
           body: "{\"client_id\":\"test\",\"client_secret\":\"client_secret\",\"grant_type\":\"client_credentials\"}",
           headers: {
       	  'Content-Type'=>'application/json',
           }).
         to_return(status: 200, body: login_response, headers: {'Content-Type'=>'application/json'})
      end

      it('token body response') do
        expect(token_api.post.body).to eq(expected_body)
      end

      it('get token value') do
        expect(token_api.token).to eq(access_token)
      end

      it('inspect token') do
        expect(token_api.inspect).to eq("#<Tatpetfinder::TokenAPI>")
      end
  end

  describe('#initialize bad response') do
    subject(:token_api) { described_class.new(client_id: client_id, client_secret: client_secret) }
  
    before do
      stub_request(:post, "https://api.petfinder.com/v2/oauth2/token").
         with(
           body: "{\"client_id\":\"test\",\"client_secret\":\"client_secret\",\"grant_type\":\"client_credentials\"}",
           headers: {
       	  'Content-Type'=>'application/json',
           }).
           to_return(status: 400, body: nil, headers: {})
    end

    it('get 400 response') do
      expect(token_api.token).to be_nil
    end
  end 

  describe('#initialize bad input') do
      it { expect { described_class.new(client_id: client_id, client_secret: "") }.to raise_error(StandardError) }
  end 
end 
  