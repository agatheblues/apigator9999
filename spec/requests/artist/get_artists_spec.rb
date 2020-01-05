require 'rails_helper'

describe "GET /artists gets all artist", :type => :request do
  context 'when authenticated' do
    let!(:artists) { 
      list = FactoryBot.create_list(:album, 10)
      artists = list.map { |album| album.artists}
      artists.flatten
    }

    before {get '/artists', headers: authenticated_header}

    it 'returns all artists' do
      expect(json['artists'].size).to eq(artists.length)
      expect(json['total_artists']).to eq(artists.length)
      expect(json['total_albums']).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'has the correct schema' do
      expect(response).to match_json_schema("artist/artists")
    end
  end

  context 'when unauthenticated' do
    before {get '/artists'}

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end

describe "GET /artists/:id gets the artist", :type => :request do
  let!(:id) { FactoryBot.create(:album).artists[0].id }
  
  context 'when authenticated' do
    before {get "/artists/#{id}", headers: authenticated_header}

    it 'returns the correct artist' do
      expect(json['id']).to eq(id)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'has the correct schema' do
      expect(response).to match_json_schema("artist/artist")
    end
  end

  context 'when unauthenticated' do
    before {get "/artists/#{id}"}

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end