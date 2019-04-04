require 'rails_helper'

RSpec.describe 'Artists API', type: :request do
  # initialize test data 
  let!(:artists) { create_list(:artist, 10) }
  let(:artist_id) { artists.first.id }

  # Test suite for GET /artists
  describe 'GET /artists' do
    # make HTTP get request before each example
    before { get '/artists' }

    it 'returns artists' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /artists/:id
  describe 'GET /artists/:id' do
    before { get "/artists/#{artist_id}" }

    context 'when the record exists' do
      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(artist_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:artist_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  # Test suite for POST /artists
  describe 'POST /artists' do
    # valid payload
    let(:valid_attributes) { { name: 'My band', img_url: 'http://myband.com' } }

    context 'when the request is valid' do
      before { post '/artists', params: valid_attributes }

      it 'creates an artist' do
        expect(json['name']).to eq('My band')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/artists', params: { name: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Created by can't be blank/)
      end
    end
  end

  # Test suite for PUT /artists/:id
  describe 'PUT /artists/:id' do
    let(:valid_attributes) { { name: 'My other band' } }

    context 'when the record exists' do
      before { put "/artists/#{artist_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /artists/:id
  describe 'DELETE /artists/:id' do
    before { delete "/artists/#{artist_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end