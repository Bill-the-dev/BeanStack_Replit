require 'rails_helper'

RSpec.describe 'Items Api', type: :request do
  # initialize data

  # -- all items --
  let!(:items) do 
    10.times do 
      FactoryBot.create(:item)
    end
  end

  # -- single item --
  let(:item_id){1}

    
  # GET /items - INDEX
  describe "GET /api/v1/items" do
    
    before { get '/api/v1/items' }
      
    it 'returns items ' do
      expect(JSON.parse(response.body)).not_to be_empty
      expect(JSON.parse(response.body).size).to eq(10)
    end
	  
	  it 'returns status code 200' do
	  	expect(response).to have_http_status(200)
	  end	
  end
    
  # GET /items/:id - SHOW
  describe "GET /items/:id" do
    
    before { get "/api/v1/items/#{item_id}" }

    context 'when the record exists' do
      it 'returns item' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['id']).to eq(item_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end  

    context 'when the record does not exist' do  
      let(:item_id){100}
      
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end 	
    end	
  end

  # POST /items - CREATE 
  describe "POST /api/v1/items" do
    let(:valid_attributes) {{item: {name: 'Code Fuel', vendor: 'Mtn Brew', price: 8.99, description: 'gross, neon-green', category: 'Espresso', user_id: '1'}}}
    
    context "when the request is valid" do
      before { post '/api/v1/items', params: valid_attributes } 
      
      it "successfully creates an item" do
        expect(JSON.parse(response.body)['name']).to eq('Code Fuel')
      end

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end	
    end

    context "when the request is invalid" do
      before {post '/api/v1/items', params: {item: {name: 'Code Fuel', vendor: 'Mtn Brew', price: -8.99, description: 'gross, neon-green', category: 'Espresso', user_id: '1'}} }
      
      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
    end	
  end
    
  # PUT /items/:id - UPDATE 
  describe "PUT /api/v1/items/:id" do
    let(:valid_attributes) {{ item: { name: 'Kicking Horse', quantity: 22 }}}	
	
    context "when the item is updated" do
      before { put "/api/v1/items/#{item_id}", params: valid_attributes }
      
      it "successfully updates record" do
        expect(JSON.parse(response.body)['name']).to eq('Kicking Horse')
      end
      
      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end	
    end

    context "when request attributes are invalid" do
      before { put "/api/v1/items/#{item_id}", params: { item: {name: nil}}}
      
      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
    end
  end

	# DELETE /items/:id - DESTROY
	describe "DELETE /api/v1/items/:id" do
    context "when the item is deleted"
      before { delete "/api/v1/items/#{item_id}" }	
      
      it "returns status code 204" do
        expect(response).to have_http_status(204)
      end
  end
end	
 
