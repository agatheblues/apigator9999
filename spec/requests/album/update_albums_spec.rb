# frozen_string_literal: true

require 'rails_helper'

describe 'PATCH /albums/:id updates the album', type: :request do
  subject(:call) { patch "/albums/#{id}", params: params, headers: headers }
  let(:id) { album.id }
  let(:headers) { admin_authenticated_header }
  let(:album) { FactoryBot.create(:album) }

  context 'when authenticated' do
    let(:genre) { { 'name' => 'dogdubs' } }
    let(:style) { { 'name' => 'dubsdog' } }
    let(:artist) do
      {
        'name' => 'Artist 1',
        'img_url' => 'https://placekitten.com/200/300',
        'discogs_id' => 'discogs_1'
      }
    end
    let(:album_params) do
      {
        'name' => 'Pickles',
        'added_at' => Time.zone.now.to_s,
        'release_date' => '2016-01-01',
        'total_tracks' => '12',
        'img_url' => 'https://placekitten.com/200/300',
        'img_width' => '200',
        'img_height' => '300',
        'spotify_id' => 'spotify_pickle',
        'discogs_id' => 'discogs_pickle'
      }
    end
    let(:update_album) { instance_double(UpdateAlbum) }

    context 'with valid id' do
      let(:params) { format_params(album_params, [artist], [genre], [style]) }

      it 'returns 201 and correct album' do
        expect(UpdateAlbum).to receive(:new).with(
          album,
          ActionController::Parameters.new(album_params).permit!,
          [ActionController::Parameters.new(artist).permit!],
          [ActionController::Parameters.new(genre).permit!],
          [ActionController::Parameters.new(style).permit!]
        )
                                            .and_return(update_album)
        expect(update_album).to receive(:call).and_return(album)
        call
        expect(response).to have_http_status(:ok)
        expect(response).to match_json_schema('album/album_extended')
      end
    end

    context 'with invalid id' do
      let(:id) { -1 }
      let(:params) { {} }

      it 'returns status code 404 and error message' do
        call
        expect(response).to have_http_status(:not_found)
        expect(response).to match_json_schema('error/error')
      end
    end
  end

  context 'when authenticated but admin' do
    let(:params) { {} }
    let(:headers) { authenticated_header }

    it 'returns unauthorized' do
      call
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end

  context 'when unauthenticated' do
    let(:params) { {} }
    let(:headers) { nil }

    it 'returns unauthorized' do
      call
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end

  private

  def format_params(album_params, artists, genres, styles)
    params = album_params.clone
    params['artists'] = artists
    params['genres'] = genres
    params['styles'] = styles
    params
  end
end
