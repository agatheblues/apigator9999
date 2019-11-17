require 'rails_helper'

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