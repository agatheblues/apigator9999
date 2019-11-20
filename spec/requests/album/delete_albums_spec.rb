require 'rails_helper'

describe "DELETE /albums/:id deletes the album", :type => :request do
  context "with artists and genres that do not have other albums" do
    setup do
      @album = FactoryBot.attributes_for(:album)
      @artists = FactoryBot.attributes_for_list(:artist, 2)
      @genres = FactoryBot.attributes_for_list(:genre, 2)
      @album['artists'] = @artists
      @album['genres'] = @genres
    end

    before :each do
      post "/albums", params: @album
    end

    it 'deletes the album' do
      expect{
        delete "/albums/#{json['id']}"
      }.to change(Album, :count).by(-1)
    end

    it 'deletes the artists' do
      expect{
        delete "/albums/#{json['id']}"
      }.to change(Artist, :count).by(-2)
    end

    it 'deletes the genres' do
      expect{
        delete "/albums/#{json['id']}"
      }.to change(Genre, :count).by(-2)
    end

    it 'returns status code 204' do
      delete "/albums/#{json['id']}"
      expect(response).to have_http_status(:no_content)
    end
  end

  context "with artists that do have other albums" do
    setup do
      @existing_album = FactoryBot.attributes_for(:album)
      @artists = FactoryBot.attributes_for_list(:artist, 2)
      @existing_album['artists'] = [@artists[0]]
      @album = FactoryBot.attributes_for(:album)
      @album['artists'] = @artists
    end

    before :each do
      post "/albums", params: @existing_album
      post "/albums", params: @album
    end

    it 'deletes the album' do
      expect{
        delete "/albums/#{json['id']}"
      }.to change(Album, :count).by(-1)
    end

    it 'deletes artist without other album' do
      expect{
        delete "/albums/#{json['id']}"
      }.to change(Artist, :count).by(-1)
    end

    it 'does not delete artist with other album' do
      delete "/albums/#{json['id']}"
      should_exist_id = json['artists'][0]['id']
      should_not_exist_id = json['artists'][1]['id']
      expect(Artist.exists?(should_exist_id)).to be true
      expect(Artist.exists?(should_not_exist_id)).to be false
    end
    
    it 'returns status code 204' do
      delete "/albums/#{json['id']}"
      expect(response).to have_http_status(:no_content)
    end
  end
  
  context "with genres that do have other albums" do
    setup do
      @existing_album = FactoryBot.attributes_for(:album)
      @artists = FactoryBot.attributes_for_list(:artist, 2)
      @genres = FactoryBot.attributes_for_list(:genre, 2)
      @existing_album['genres'] = [@genres[0]]
      @existing_album['artists'] = @artists
      @album = FactoryBot.attributes_for(:album)
      @album['genres'] = @genres
      @album['artists'] = @artists
    end

    before :each do
      post "/albums", params: @existing_album
      post "/albums", params: @album
    end

    it 'deletes the album' do
      expect{
        delete "/albums/#{json['id']}"
      }.to change(Album, :count).by(-1)
    end

    it 'deletes genre without other album' do
      expect{
        delete "/albums/#{json['id']}"
      }.to change(Genre, :count).by(-1)
    end

    it 'does not delete genre with other album' do
      delete "/albums/#{json['id']}"
      should_exist_id = json['genres'][0]['id']
      should_not_exist_id = json['genres'][1]['id']
      expect(Genre.exists?(should_exist_id)).to be true
      expect(Genre.exists?(should_not_exist_id)).to be false
    end
    
    it 'returns status code 204' do
      delete "/albums/#{json['id']}"
      expect(response).to have_http_status(:no_content)
    end
  end

  context "with invalid id" do
    before {delete "/albums/-1"}

    it 'returns status code 404' do
      expect(response).to have_http_status(:not_found)
    end

    it 'returns an error message' do
      expect(response).to match_json_schema("error/error")
    end
  end
end