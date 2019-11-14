require 'rails_helper'

describe "GET /albums gets all albums", :type => :request do
  let!(:albums) { FactoryBot.create_list(:album, 10)}

  before {get '/albums'}

  it 'returns all albums' do
    expect(json.size).to eq(10)
  end

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end

  it 'has the correct schema' do
    expect(response).to match_json_schema("album/albums")
  end
end

describe "GET /albums/:id gets the album", :type => :request do
  let!(:id) { FactoryBot.create(:album).id }
  before {get "/albums/#{id}"}

  it 'returns the correct album' do
    expect(json['id']).to eq(id)
  end

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end

  it 'has the correct schema' do
    expect(response).to match_json_schema("album/album_extended")
  end
end