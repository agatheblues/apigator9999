require 'rails_helper'

describe "PATCH /albums/:id updates the album", :type => :request do
  context 'when authenticated' do
    context "with valid id" do
      setup do
        @album = FactoryBot.attributes_for(:album)
        @artists = FactoryBot.attributes_for_list(:artist, 2)
        @genres = FactoryBot.attributes_for_list(:genre, 2)
        @styles = FactoryBot.attributes_for_list(:style, 2)
        @album['artists'] = @artists
        @album['genres'] = @genres
        @album['styles'] = @styles
        @update_params = FactoryBot.attributes_for(:album)
        @update_params['artists'] = @artists.dup << FactoryBot.attributes_for(:artist)
        @update_params['genres'] = @genres.dup << FactoryBot.attributes_for(:genre)
        @update_params['styles'] = @styles.dup << FactoryBot.attributes_for(:style)
      end

      before :each do
        post "/albums", params: @album, headers: authenticated_header
        @id = json['id']
      end

      it 'returns the correct album' do
        patch "/albums/#{@id}", params: @update_params, headers: authenticated_header
        expect(json['id']).to eq(@id)
      end

      it 'returns status code 200' do
        patch "/albums/#{@id}", params: @update_params, headers: authenticated_header
        expect(response).to have_http_status(:ok)
      end

      it 'has the correct schema' do
        patch "/albums/#{@id}", params: @update_params, headers: authenticated_header
        expect(response).to match_json_schema("album/album_extended")
      end

      it 'updated the album' do
        patch "/albums/#{@id}", params: @update_params, headers: authenticated_header
        json = JSON.parse(response.body)
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

      it 'updated the artists' do
        expect{
          patch "/albums/#{@id}", params: @update_params, headers: authenticated_header
        }.to change(Artist, :count).by(1)
      end

      it 'updated the genres' do
        expect{
          patch "/albums/#{@id}", params: @update_params, headers: authenticated_header
        }.to change(Genre, :count).by(1)
      end

      it 'updated the styles' do
        expect{
          patch "/albums/#{@id}", params: @update_params, headers: authenticated_header
        }.to change(Style, :count).by(1)
      end
    end

    context "with invalid id" do
      before {patch "/albums/-1", headers: authenticated_header}

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        expect(response).to match_json_schema("error/error")
      end
    end
  end
  
  context 'when unauthenticated' do
    let(:album) { FactoryBot.create(:album) }
    before {patch "/albums/#{album['id']}", params: {}}

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end