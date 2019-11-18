require 'rails_helper'

describe "GET /albums gets all albums", :type => :request do
  setup do 
    @albums = FactoryBot.create_list(:album, 10)
  end

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
  context "with valid id" do
    setup do
      @id = FactoryBot.create(:album).id
    end

    before {get "/albums/#{@id}"}

    it 'returns the correct album' do
      expect(json['id']).to eq(@id)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'has the correct schema' do
      expect(response).to match_json_schema("album/album_extended")
    end
  end

  context "with invalid id" do
    before {get "/albums/-1"}

    it 'returns status code 404' do
      expect(response).to have_http_status(:not_found)
    end

    it 'returns an error message' do
      expect(response).to match_json_schema("error/error")
    end
  end
end