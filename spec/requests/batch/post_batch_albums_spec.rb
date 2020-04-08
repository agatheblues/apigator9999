# frozen_string_literal: true

require 'rails_helper'

describe 'POST /batch/albums', type: :request do
  context 'when authenticated' do
    subject(:call) { post '/batch/albums', params: params, headers: authenticated_header }

    let(:genre) { { 'name' => 'dogdubs' } }
    let(:style) { { 'name' => 'dubsdog' } }
    let(:artist1) do
      {
        'name' => 'Artist 1',
        'img_url' => 'https://placekitten.com/200/300',
        'discogs_id' => 'discogs_1'
      }
    end
    let(:album_params1) do
      {
        'name' => 'Pickles',
        'added_at' => Time.zone.now.to_s,
        'release_date' => '2016-01-01',
        'total_tracks' => '12',
        'img_url' => 'https://placekitten.com/200/300',
        'img_width' => '200',
        'img_height' => '300',
        'spotify_id' => 'spotify_pickle1',
        'discogs_id' => 'discogs_pickle1'
      }
    end
    let(:artist2) do
      {
        'name' => 'Artist 2',
        'img_url' => 'https://placekitten.com/200/300',
        'discogs_id' => 'discogs_2'
      }
    end
    let(:album_params2) do
      {
        'name' => 'Pickles',
        'added_at' => Time.zone.now.to_s,
        'release_date' => '2016-01-01',
        'total_tracks' => '12',
        'img_url' => 'https://placekitten.com/200/300',
        'img_width' => '200',
        'img_height' => '300',
        'spotify_id' => 'spotify_pickle2',
        'discogs_id' => 'discogs_pickle2'
      }
    end
    let(:create_album) { instance_double(CreateAlbum) }

    context 'with valid attributes' do
      let(:album) { FactoryBot.create(:album) }
      let(:params) do
        {
          'albums' => [
            format_params(album_params1, [artist1], [genre], [style]),
            format_params(album_params2, [artist1, artist2], [], [])
          ]
        }
      end

      it 'returns 201 and correct schema' do
        expect(CreateAlbum).to receive(:new).with(
          ActionController::Parameters.new(album_params1).permit!,
          [ActionController::Parameters.new(artist1).permit!],
          [ActionController::Parameters.new(genre).permit!],
          [ActionController::Parameters.new(style).permit!]
        )
                                            .and_return(create_album)
        expect(create_album).to receive(:call).and_return(album)
        expect(CreateAlbum).to receive(:new).with(
          ActionController::Parameters.new(album_params2).permit!,
          [ActionController::Parameters.new(artist1).permit!,
           ActionController::Parameters.new(artist2).permit!],
          [],
          []
        )
                                            .and_return(create_album)
        expect(create_album).to receive(:call).and_return(album)
        call
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      let(:params) { { foo: 'bar' } }

      it 'returns status code 400' do
        call
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'with invalid albums attributes' do
      let(:params) { { 'albums': [{ foo: 'bar' }] } }

      it 'returns status code 400' do
        expect(CreateAlbum).to receive(:new).and_return(create_album)
        expect(create_album).to receive(:call).and_raise(ActiveRecord::RecordInvalid)
        call
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'with no artists' do
      let(:params) { { 'albums': [{ foo: 'bar' }] } }

      it 'returns status code 400' do
        expect(CreateAlbum).to receive(:new).and_return(create_album)
        expect(create_album).to receive(:call).and_raise(CreateOrUpdateArtists::ArtistsMissingError)
        call
        expect(response).to have_http_status(:bad_request)
        expect(response).to match_json_schema('error/error')
        expect(json['message']).to eq('artists should not be blank')
      end
    end

    context 'with an already existing album' do
      let(:params) { { 'albums': [{ foo: 'bar' }] } }

      it 'returns status code 409' do
        expect(CreateAlbum).to receive(:new).and_return(create_album)
        expect(create_album).to receive(:call).and_raise(ActiveRecord::RecordNotUnique)
        call
        expect(response).to have_http_status(:conflict)
        expect(response).to match_json_schema('error/error')
      end
    end
  end

  context 'when unauthenticated' do
    let(:album) { FactoryBot.attributes_for(:album) }
    before { post '/batch/albums', params: { 'albums': [album] } }

    it 'returns unauthorized' do
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
