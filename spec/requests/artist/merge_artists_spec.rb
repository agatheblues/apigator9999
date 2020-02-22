# frozen_string_literal: true

require 'rails_helper'

describe 'POST /artists/:id1,:id2 merge both artists', type: :request do
  context 'when authenticated' do
    subject(:call) { post "/artists/#{id1},#{id2}", headers: authenticated_header }

    context 'with artists that exist' do
      let(:artists) { FactoryBot.create_list(:artist, 3) }
      let(:id1) { artists[0].id }
      let(:id2) { artists[1].id }
      let(:merge_artists) { instance_double(MergeArtists) }

      it 'calls the right service and returns :ok' do
        expect(MergeArtists).to receive(:new).with(artists[0], artists[1]).and_return(merge_artists)
        expect(merge_artists).to receive(:call).and_return(artists[2])
        call
        expect(response).to have_http_status(:ok)
          .and match_json_schema('artist/artist')
      end
    end

    context 'with artists that cannot be merged' do
      let(:artists) { FactoryBot.create_list(:artist, 3) }
      let(:id1) { artists[0].id }
      let(:id2) { artists[1].id }
      let(:merge_artists) { instance_double(MergeArtists) }

      it 'calls the right service and returns :unprocessable_entity' do
        expect(MergeArtists).to receive(:new).with(artists[0], artists[1]).and_return(merge_artists)
        expect(merge_artists).to receive(:call).and_raise(ActiveRecord::RecordInvalid)
        call
        expect(response).to have_http_status(:unprocessable_entity)
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

  context 'when unauthenticated' do
    let(:album) { FactoryBot.create(:album, artists_count: 2) }

    before { post "/artists/#{album.artists[0].id},#{album.artists[1].id}" }

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end
