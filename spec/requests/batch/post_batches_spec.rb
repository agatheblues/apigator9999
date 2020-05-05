# frozen_string_literal: true

require 'rails_helper'

describe 'POST /batches', type: :request do
  subject(:call) { post '/batches', params: params, headers: headers }
  let(:headers) { admin_authenticated_header }

  context 'when authenticated' do
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
    let(:create_album_worker) { instance_double(CreateAlbumsWorker) }

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

      it 'returns 201 and creates a batch' do
        expect(CreateAlbumsWorker).to receive(:perform_async).and_return('a_job_id')
        expect { call }.to change(Batch, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(Batch.last).to have_attributes(
          {
            job_id: 'a_job_id',
            data: params['albums']
          }
        )
      end
    end

    context 'with invalid attributes' do
      let(:params) { { foo: 'bar' } }

      it 'returns status code 400' do
        call
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  context 'when authenticated but admin' do
    let(:album) { FactoryBot.attributes_for(:album) }
    let(:params) { { 'albums': [album] } }
    let(:headers) { authenticated_header }

    it 'returns unauthorized' do
      call
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end

  context 'when unauthenticated' do
    let(:album) { FactoryBot.attributes_for(:album) }
    let(:params) { { 'albums': [album] } }
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
