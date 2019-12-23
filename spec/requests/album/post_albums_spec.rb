require 'rails_helper'

describe "POST /albums", :type => :request do
  context 'when authenticated' do
    setup do
      @album = FactoryBot.attributes_for(:album)
      @artists = FactoryBot.attributes_for_list(:artist, 3)
      @genres = FactoryBot.attributes_for_list(:genre, 3)
      @styles = FactoryBot.attributes_for_list(:style, 3)
      @album['artists'] = @artists
      @album['genres'] = @genres
      @album['styles'] = @styles
    end

    context "with valid attributes" do
      it "creates a new album" do
        expect{
          post "/albums", params: @album, headers: authenticated_header
        }.to change(Album, :count).by(1)
      end
      
      it "creates new artists" do
        expect{
          post "/albums", params: @album, headers: authenticated_header
        }.to change(Artist, :count).by(3)
      end

      it "creates new genres" do
        expect{
          post "/albums", params: @album, headers: authenticated_header
        }.to change(Genre, :count).by(3)
      end

      it "creates new styles" do
        expect{
          post "/albums", params: @album, headers: authenticated_header
        }.to change(Style, :count).by(3)
      end

      it 'returns the correct album' do
        post "/albums", params: @album, headers: authenticated_header
        expect(json['name']).to eq(@album[:name])
      end

      it 'computes artists total tracks and albums' do
        post "/albums", params: @album, headers: authenticated_header
        first_artist = json['artists'][0]
        expect(first_artist['total_tracks']).to eq(12)
        expect(first_artist['total_albums']).to eq(1)
      end
    
      it 'returns status code 201' do
        post "/albums", params: @album, headers: authenticated_header
        expect(response).to have_http_status(:created)
      end
    
      it 'has the correct schema' do
        post "/albums", params: @album, headers: authenticated_header
        expect(response).to match_json_schema("album/album_extended")
      end
    end
    
    context "with invalid album attributes" do
      setup do
        @invalid_album = FactoryBot.attributes_for(:album, name: nil)
        @artists = FactoryBot.attributes_for_list(:artist, 3)
        @genres = FactoryBot.attributes_for_list(:genre, 3)
        @styles = FactoryBot.attributes_for_list(:style, 3)
        @invalid_album['artists'] = @artists
        @invalid_album['genres'] = @genres
        @invalid_album['styles'] = @styles
      end

      it "does not save the new album" do
        expect{
          post "/albums", params: @invalid_album, headers: authenticated_header
        }.to_not change(Album, :count)
      end
      
      it "does not save the artists" do
        expect{
          post "/albums", params: @invalid_album, headers: authenticated_header
        }.to_not change(Artist, :count)
      end

      it "does not save the genres" do
        expect{
          post "/albums", params: @invalid_album, headers: authenticated_header
        }.to_not change(Genre, :count)
      end
      
      it "does not save the styles" do
        expect{
          post "/albums", params: @invalid_album, headers: authenticated_header
        }.to_not change(Style, :count)
      end

      it 'returns status code 400' do
        post "/albums", params: @invalid_album, headers: authenticated_header
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        post "/albums", params: @invalid_album, headers: authenticated_header
        expect(response).to match_json_schema("error/error")
      end
    end 

    context "with invalid artist attributes" do
      setup do
        @album = FactoryBot.attributes_for(:album)
        @invalid_artist = FactoryBot.attributes_for(:artist, name: nil)
        @genres = FactoryBot.attributes_for_list(:genre, 3)
        @styles = FactoryBot.attributes_for_list(:style, 3)
        @album['artists'] = [@invalid_artist]
        @album['genres'] = @genres
        @album['styles'] = @styles
      end

      it "does not save the new album" do
        expect{
          post "/albums", params: @album, headers: authenticated_header
        }.to_not change(Album, :count)
      end
      
      it "does not save the artists" do
        expect{
          post "/albums", params: @album, headers: authenticated_header
        }.to_not change(Artist, :count)
      end

      it "does not save the genres" do
        expect{
          post "/albums", params: @album, headers: authenticated_header
        }.to_not change(Genre, :count)
      end

      it "does not save the styles" do
        expect{
          post "/albums", params: @album, headers: authenticated_header
        }.to_not change(Style, :count)
      end

      it 'returns status code 400' do
        post "/albums", params: @album, headers: authenticated_header
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        post "/albums", params: @album, headers: authenticated_header
        expect(response).to match_json_schema("error/error")
      end
    end 

    context "with no artists" do
      setup do
        @album = FactoryBot.attributes_for(:album)
      end

      it "does not save the new album" do
        expect{
          post "/albums", params: @album, headers: authenticated_header
        }.to_not change(Album, :count)
      end
      
      it 'returns status code 400' do
        post "/albums", params: @album, headers: authenticated_header
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        post "/albums", params: @album, headers: authenticated_header
        expect(response).to match_json_schema("error/error")
      end
    end 

    context "with an already existing artist" do
      setup do
        @artist = FactoryBot.create(:artist, total_albums: 1, total_tracks: 12)
        artist_attributes = @artist.attributes
        artist_attributes['name'] = "Larry"
        @album = FactoryBot.attributes_for(:album)
        @album['artists'] = [artist_attributes]
      end

      it "creates a new album" do
        expect{
          post "/albums", params: @album, headers: authenticated_header
        }.to change(Album, :count).by(1)
      end
      
      it 'returns status code 201' do
        post "/albums", params: @album, headers: authenticated_header
        expect(response).to have_http_status(:created)
      end

      it "does not create a new artist" do
        expect{
          post "/albums", params: @album, headers: authenticated_header
        }.to_not change(Artist, :count)
      end

      it 'updates artist total tracks and albums' do
        post "/albums", params: @album, headers: authenticated_header
        first_artist = json['artists'][0]
        expect(first_artist['total_tracks']).to eq(24)
        expect(first_artist['total_albums']).to eq(2)
      end

      it "updates exiting artist" do
        post "/albums", params: @album, headers: authenticated_header
        @artist.reload
        expect(@artist.name).to eq("Larry")
      end
    end 

    context "with an already existing genre" do
      setup do
        @genre = FactoryBot.create(:genre)
        @album = FactoryBot.attributes_for(:album)
        @artist = FactoryBot.attributes_for(:artist)
        @album['artists'] = [@artist]
        @album['genres'] = [@genre.attributes]
      end

      it "creates a new album" do
        expect{
          post "/albums", params: @album, headers: authenticated_header
        }.to change(Album, :count).by(1)
      end
      
      it 'returns status code 201' do
        post "/albums", params: @album, headers: authenticated_header
        expect(response).to have_http_status(:created)
      end

      it "does not create a new genre" do
        expect{
          post "/albums", params: @album, headers: authenticated_header
        }.to_not change(Genre, :count)
      end
    end 

    context "with an already existing style" do
      setup do
        @style = FactoryBot.create(:style)
        @album = FactoryBot.attributes_for(:album)
        @artist = FactoryBot.attributes_for(:artist)
        @album['artists'] = [@artist]
        @album['styles'] = [@style.attributes]
      end

      it "creates a new album" do
        expect{
          post "/albums", params: @album, headers: authenticated_header
        }.to change(Album, :count).by(1)
      end
      
      it 'returns status code 201' do
        post "/albums", params: @album, headers: authenticated_header
        expect(response).to have_http_status(:created)
      end

      it "does not create a new style" do
        expect{
          post "/albums", params: @album, headers: authenticated_header
        }.to_not change(Style, :count)
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
          post "/albums", params: @same_album, headers: authenticated_header
        }.to_not change(Album, :count)
      end
      
      it 'returns status code 400' do
        post "/albums", params: @same_album, headers: authenticated_header
        expect(response).to have_http_status(:conflict)
      end

      it 'returns an error message' do
        post "/albums", params: @same_album, headers: authenticated_header
        expect(response).to match_json_schema("error/error")
      end
    end 
  end

  context 'when unauthenticated' do
    let(:album) { FactoryBot.attributes_for(:album) }
    before {post '/albums', params: album}

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end
