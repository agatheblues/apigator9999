require 'rails_helper'

describe "GET /artists gets all artist", :type => :request do
  let!(:artists) { 
    list = FactoryBot.create_list(:album, 10)
    artists = list.map { |album| album.artists}
    artists.flatten
  }

  before {get '/artists'}

  it 'returns all artists' do
    expect(json.size).to eq(artists.length)
  end

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end

  it 'has the correct schema' do
    expect(response).to match_json_schema("artist/artists")
  end
end

describe "GET /artists/:id gets the artist", :type => :request do
  let!(:id) { FactoryBot.create(:album).artists[0].id }
  before {get "/artists/#{id}"}

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