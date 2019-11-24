require 'rails_helper'

describe "GET /genres gets all genres", :type => :request do
  let!(:genres) { 
    list = FactoryBot.create_list(:album, 10)
    genres = list.map { |album| album.genres}
    genres.flatten
  }

  before {get '/genres'}

  it 'returns all genres' do
    expect(json.size).to eq(genres.length)
  end

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end

  it 'has the correct schema' do
    expect(response).to match_json_schema("genre/genres")
  end
end