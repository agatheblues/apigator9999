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

describe "POST /albums", :type => :request do
  setup do
    @album = FactoryBot.attributes_for(:album)
    @artists = FactoryBot.attributes_for_list(:artist, 3)
    @album['artists'] = @artists
  end

  context "with valid attributes" do
    it "creates a new album" do
      expect{
        post "/albums", params: @album
      }.to change(Album, :count).by(1)
    end
    
    it "creates new artists" do
      expect{
        post "/albums", params: @album
      }.to change(Artist, :count).by(3)
    end

    it 'returns the correct album' do
      post "/albums", params: @album
      expect(json['name']).to eq(@album[:name])
    end
  
    it 'returns status code 201' do
      post "/albums", params: @album
      expect(response).to have_http_status(:created)
    end
  
    it 'has the correct schema' do
      post "/albums", params: @album
      expect(response).to match_json_schema("album/album_extended")
    end
  end
  
  context "with invalid album attributes" do
    setup do
      @invalid_album = FactoryBot.attributes_for(:album, name: nil)
      @artists = FactoryBot.attributes_for_list(:artist, 3)
      @album['artists'] = @artists
    end

    it "does not save the new album" do
      expect{
        post "/albums", params: @invalid_album
      }.to_not change(Album, :count)
    end
    
    it "does not save the artists" do
      expect{
        post "/albums", params: @invalid_album
      }.to_not change(Artist, :count)
    end

    it 'returns status code 400' do
      post "/albums", params: @invalid_album
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns an error message' do
      post "/albums", params: @invalid_album
      expect(response).to match_json_schema("error/error")
    end
  end 

  context "with invalid artist attributes" do
    setup do
      @album = FactoryBot.attributes_for(:album)
      @artist = FactoryBot.attributes_for(:artist, name: nil)
      @album['artists'] = [@artist]
    end

    it "does not save the new album" do
      expect{
        post "/albums", params: @invalid_album
      }.to_not change(Album, :count)
    end
    
    it "does not save the artists" do
      expect{
        post "/albums", params: @invalid_album
      }.to_not change(Artist, :count)
    end

    it 'returns status code 400' do
      post "/albums", params: @invalid_album
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns an error message' do
      post "/albums", params: @invalid_album
      expect(response).to match_json_schema("error/error")
    end
  end 

  context "with no artists" do
    setup do
      @album = FactoryBot.attributes_for(:album)
    end

    it "does not save the new album" do
      expect{
        post "/albums", params: @album
      }.to_not change(Album, :count)
    end
    
    it 'returns status code 400' do
      post "/albums", params: @album
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns an error message' do
      post "/albums", params: @album
      expect(response).to match_json_schema("error/error")
    end
  end 

  context "with an already existing artist" do
    setup do
      @artist = FactoryBot.create(:artist)
      artist_attributes = @artist.attributes
      artist_attributes['name'] = "Larry"
      @album = FactoryBot.attributes_for(:album)
      @album['artists'] = [artist_attributes]
    end

    it "creates a new album" do
      expect{
        post "/albums", params: @album
      }.to change(Album, :count).by(1)
    end
    
    it 'returns status code 201' do
      post "/albums", params: @album
      expect(response).to have_http_status(:created)
    end

    it "does not create a new artist" do
      expect{
        post "/albums", params: @album
      }.to change(Artist, :count).by(0)
    end

    it "updates exiting artist" do
      post "/albums", params: @album
      @artist.reload
      expect(@artist.name).to eq("Larry")
    end
  end 

  context "with an already existing album" do
    setup do
      @album = FactoryBot.create(:album)
      @artist = FactoryBot.attributes_for(:artist)
      @same_album = @album.attributes
      @same_album['artists'] = [@artist]
    end

    it "does not create a new album" do
      expect{
        post "/albums", params: @same_album
      }.to change(Album, :count).by(0)
    end
    
    it 'returns status code 400' do
      post "/albums", params: @same_album
      expect(response).to have_http_status(:conflict)
    end

    it 'returns an error message' do
      post "/albums", params: @same_album
      expect(response).to match_json_schema("error/error")
    end
  end 
end

describe "PATCH /albums/:id updates the album", :type => :request do
  context "with valid id" do
    setup do
      @id = FactoryBot.create(:album).id
      @update_params = FactoryBot.attributes_for(:album)
    end

    before {patch "/albums/#{@id}", params: @update_params}

    it 'returns the correct album' do
      expect(json['id']).to eq(@id)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'has the correct schema' do
      expect(response).to match_json_schema("album/album_extended")
    end

    it 'updated the album' do
      expect(json['name']).to eq(@update_params[:name])
      expect(json['added_at']).to eq(@update_params[:added_at])
      expect(json['release_date']).to eq(@update_params[:release_date])
      expect(json['total_tracks']).to eq(@update_params[:total_tracks])
      expect(json['img_url']).to eq(@update_params[:img_url])
      expect(json['img_width']).to eq(@update_params[:img_width])
      expect(json['img_height']).to eq(@update_params[:img_height])
      expect(json['spotify_id']).to eq(@update_params[:spotify_id])
      expect(json['discogs_id']).to eq(@update_params[:discogs_id])
    end
  end

  context "with invalid id" do
    before {patch "/albums/-1"}

    it 'returns status code 404' do
      expect(response).to have_http_status(:not_found)
    end

    it 'returns an error message' do
      expect(response).to match_json_schema("error/error")
    end
  end
end