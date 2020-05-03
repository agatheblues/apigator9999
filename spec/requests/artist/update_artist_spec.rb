# frozen_string_literal: true

require 'rails_helper'

describe 'PATCH /artists/:id updates artist', type: :request do
  subject(:call) { patch "/artists/#{id}", params: params, headers: headers }
  let(:headers) { admin_authenticated_header }
  let(:artist) { FactoryBot.create(:artist) }
  let(:id) { artist.id }

  before { call }

  context 'when authenticated' do
    context 'with valid params' do
      let(:params) { { spotify_id: 'foo', discogs_id: 'bar' } }

      it 'updates the artist' do
        expect(artist.reload).to have_attributes(params)
        expect(response).to have_http_status(:ok)
          .and match_json_schema('artist/artist')
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          name: 'cookie',
          img_url: 'cookie',
          total_tracks: 9999,
          total_albums: 9999
        }
      end

      it 'does not update the artist' do
        expect(artist.reload).not_to have_attributes(params)
        expect(response).to have_http_status(:ok)
          .and match_json_schema('artist/artist')
      end
    end

    context 'with artist that does not exist' do
      let(:id) { -1 }
      let(:params) { {} }

      it 'returns 404 with correct schema' do
        expect(response).to have_http_status(:not_found)
          .and match_json_schema('error/error')
      end
    end
  end

  context 'when authenticated but not admin' do
    let(:headers) { authenticated_header }
    let(:params) { {} }

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end

  context 'when unauthenticated' do
    let(:headers) { nil }
    let(:params) { {} }

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end
