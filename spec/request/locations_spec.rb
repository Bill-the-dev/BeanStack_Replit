require 'rails_helper'

RSpec.describe 'Locations Api', type: :request do
  # initialize data

  # -- all locations --
  let!(:locations) do 
    6.times do 
      FactoryBot.create(:location)
    end
  end

  # -- single location --
  let(:location_id){1}

    
  # GET /locations - INDEX
  describe "GET /api/v1/locations" do
    
    before { get '/api/v1/locations' }
      
    it 'returns locations ' do
      expect(JSON.parse(response.body)).not_to be_empty
      expect(JSON.parse(response.body).size).to eq(6)
    end
	  
	  it 'returns status code 200' do
	  	expect(response).to have_http_status(200)
	  end	
  end
    
  # GET /locations/:id - SHOW
  describe "GET /locations/:id" do
    
    before { get "/api/v1/locations/#{location_id}" }

    context 'when the record exists' do
      it 'returns location' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['id']).to eq(location_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end  

    context 'when the record does not exist' do  
      let(:location_id){999}
      
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end 	
    end	
  end

  # POST /locations - CREATE 
  describe "POST /api/v1/locations" do
    let(:valid_attributes) {{location: {city: 'Montville', state: 'NJ', country: 'US', zip: '07045', weather: '', user_id: '1'}}}
    
    context "when the request is valid" do
      before { post '/api/v1/locations', params: valid_attributes } 
      
      it "successfully creates an location" do
        expect(JSON.parse(response.body)['city']).to eq('Montville')
      end

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end	
    end

    context "when the request is invalid" do
      before {post '/api/v1/locations', params: {location: {city: '', state: 'NJ', country: 'US', zip: '07045' }}}
      
      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
    end	
  end
    
  # PUT /locations/:id - UPDATE 
  describe "PUT /api/v1/locations/:id" do
    let(:valid_attributes) {{ location: { city: 'Sparta', zip: '07871' }}}	
	
    context "when the location is updated" do
      before { put "/api/v1/locations/#{location_id}", params: valid_attributes }
      
      it "successfully updates record" do
        expect(JSON.parse(response.body)['city']).to eq('Sparta')
      end
      
      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end	
    end

    context "when request attributes are invalid" do
      before { put "/api/v1/locations/#{location_id}", params: { location: {city: nil }}}
      
      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
    end
  end

	# DELETE /locations/:id - DESTROY
	describe "DELETE /api/v1/locations/:id" do
    context "when the location is deleted"
      before { delete "/api/v1/locations/#{location_id}" }	
      
      it "returns status code 204" do
        expect(response).to have_http_status(204)
      end
  end
end	