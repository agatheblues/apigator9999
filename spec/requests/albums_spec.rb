require 'rails_helper'

RSpec.describe 'Albums API', type: :request do
  # initialize test data 
  let!(:albums) { create_list(:album, 10) }
  let(:album_id) { albums.first.id }

  # Test suite for GET /albums
  describe 'GET /albums' do
    # make HTTP get request before each example
    before { get '/albums' }

    it 'returns albums' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /albums/:id
  describe 'GET /albums/:id' do
    before { get "/albums/#{album_id}" }

    context 'when the record exists' do
      it 'returns the album' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(album_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:album_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Album/)
      end
    end
  end

  # Test suite for POST /albums
  describe 'POST /albums' do
    # valid payload
    let(:valid_attributes) { 
      { 
        name: 'My album',
        added_at: 'Feb, 25 2015',
        release_date: 'June 2018',
        total_tracks: 7,
        height: 200,
        width: 200,
        img_url: 'http://myalbum.com' 
      }
    }

    context 'when the request is valid' do
      before { post '/albums', params: valid_attributes }

      it 'creates an album' do
        expect(json['name']).to eq('My album')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/albums', params: { } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /albums/:id
  describe 'PUT /albums/:id' do
    let(:valid_attributes) { { name: 'My other album' } }

    context 'when the record exists' do
      before { put "/albums/#{album_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /albums/:id
  describe 'DELETE /albums/:id' do
    before { delete "/albums/#{album_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end