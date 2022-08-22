# frozen_string_literal: true
require('spec_helper')
require('./lib/tatpetfinder')


RSpec.describe(::Tatpetfinder::PetfinderAPI) do
    let(:access_token) { 'real-test-token' }
    let(:count_per_page) {3}
    let(:petfinder_file) { 'spec/fixtures/petfinder_response.json' }
    let(:expected_petfinder_body) {File.read(petfinder_file)}
  
    describe('#initialize petfinder happy path') do
      subject(:petfinder_api) { described_class.new(token: access_token, count_per_page: count_per_page) }

      before do
        stub_request(:get, "https://api.petfinder.com/v2/animals/?limit=3").
         with(
           headers: {
       	  'Authorization'=>'Bearer real-test-token',
       	  'Content-Type'=>'application/x-www-form-urlencoded',
           }).
           to_return(status: 200, body: expected_petfinder_body, headers: {'Content-Type'=>'application/json'})
      end

      it('pets body response') do
        pets = petfinder_api.pets("")
        expect(pets.dig(1,'breeds','primary')).to eq("Morgan")
        expect(pets.length()).to eq(3)
      end

      it('inspect pets') do
        expect(petfinder_api.inspect).to eq("#<Tatpetfinder::PetfinderAPI>")
      end
  end

  describe('#initialize bad response') do
    subject(:petfinder_api) { described_class.new(token: access_token, count_per_page: count_per_page) }

  before do
    stub_request(:get, "https://api.petfinder.com/v2/animals/?limit=3").
         with(
           headers: {
       	  'Authorization'=>'Bearer real-test-token',
       	  'Content-Type'=>'application/x-www-form-urlencoded',
           }).
           to_return(status: 404, body: nil, headers: {'Content-Type'=>'application/json'})
  end

    it('get 404 response') do
      expect(petfinder_api.pets("")).to be_empty
    end
  end 

  describe('#initialize with empty token') do
      it { expect { described_class.new(token: "") }.to raise_error(StandardError) }
  end 
end 
