# frozen_string_literal: true

require 'rails_helper'

describe 'POST /artists/:id1,:id2 merge both artists', type: :request do
  subject(:call) { post "/artists/#{id1},#{id2}", headers: headers }
  let(:headers) { admin_authenticated_header }
  let(:artists) { FactoryBot.create_list(:artist, 3) }
  let(:id1) { artists[0].id }
  let(:id2) { artists[1].id }
  let(:merge_artists) { instance_double(MergeArtists) }

  context 'when authenticated' do
    context 'with artists that exist' do
      it 'calls the right service and returns :ok' do
        expect(MergeArtists).to receive(:new).with(artists[0], artists[1]).and_return(merge_artists)
        expect(merge_artists).to receive(:call).and_return(artists[2])
        call
        expect(response).to have_http_status(:ok)
          .and match_json_schema('artist/artist')
      end
    end

    context 'with artists that cannot be merged' do
      it 'calls the right service and returns :unprocessable_entity' do
        expect(MergeArtists).to receive(:new).with(artists[0], artists[1]).and_return(merge_artists)
        expect(merge_artists).to receive(:call).and_raise(MergeArtists::ArtistsMergeInvalidError)
        call
        expect(response).to have_http_status(:bad_request)
          .and match_json_schema('error/error')
      end
    end

    context 'with artists that do not exist' do
      let(:id1) { -1 }
      let(:id2) { -1 }

      it 'returns 404 with correct schema' do
        call
        expect(response).to have_http_status(:not_found)
          .and match_json_schema('error/error')
      end
    end
  end

  context 'when authenticated but admin' do
    let(:headers) { authenticated_header }

    it 'returns unauthorized' do
      call
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end

  context 'when unauthenticated' do
    let(:headers) { nil }

    it 'returns unauthorized' do
      call
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end
