require 'rails_helper'

describe "GET /albums gets all albums", :type => :request do
  context 'when no filters are applied' do
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

  context 'when a single genre filter is applied' do
    setup do 
      @albums = FactoryBot.create_list(:album, 10)
      @genre_id = @albums[0].genres[0].id
    end

    before {get "/albums?genres=#{@genre_id}"}

    it 'returns a filtered list' do
      expect(json.size).to eq(1)
    end

    it 'returns the correct album' do
      genre_ids = json[0]['genres'].map {|genre| genre['id']}
      expect(genre_ids.include?(@genre_id)).to be true
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'has the correct schema' do
      expect(response).to match_json_schema("album/albums")
    end
  end

  context 'when multiple genre filter are applied' do
    setup do 
      @albums = FactoryBot.create_list(:album, 10)
      @genre_1 = @albums[0].genres[0].id
      @genre_2 = @albums[1].genres[0].id
    end

    before {get "/albums?genres=#{@genre_1},#{@genre_2}"}

    it 'returns a filtered list' do
      expect(json.size).to eq(2)
    end

    it 'returns the correct albums' do
      genre_ids_1 = json[0]['genres'].map {|genre| genre['id']}
      genre_ids_2 = json[1]['genres'].map {|genre| genre['id']}
      genre_ids = genre_ids_1.concat(genre_ids_2)
      expect(genre_ids.include?(@genre_1)).to be true
      expect(genre_ids.include?(@genre_2)).to be true
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'has the correct schema' do
      expect(response).to match_json_schema("album/albums")
    end
  end

  context 'when a single style filter is applied' do
    setup do 
      @albums = FactoryBot.create_list(:album, 10)
      @style_id = @albums[0].styles[0].id
    end

    before {get "/albums?styles=#{@style_id}"}

    it 'returns a filtered list' do
      expect(json.size).to eq(1)
    end

    it 'returns the correct album' do
      style_ids = json[0]['styles'].map {|style| style['id']}
      expect(style_ids.include?(@style_id)).to be true
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'has the correct schema' do
      expect(response).to match_json_schema("album/albums")
    end
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