require 'rails_helper'

describe "GET /genres gets all genres", :type => :request do
  context 'when authenticated' do
    let!(:genres) { 
      list = FactoryBot.create_list(:album, 10)
      genres = list.map { |album| album.genres}
      genres.flatten
    }

    before {get '/genres', headers: authenticated_header}

    it 'returns all genres' do
      expect(json['genres'].size).to eq(genres.length)
      expect(json['total_genres']).to eq(genres.length)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'has the correct schema' do
      expect(response).to match_json_schema("genre/genres")
    end
  end

  context 'when unauthenticated' do
    before {get '/genres'}

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end