# frozen_string_literal: true

require 'rails_helper'

describe 'DELETE /albums/:id deletes the album', type: :request do
  context 'when authenticated' do
    subject(:call) { delete "/albums/#{album.id}", headers: authenticated_header }
    let(:album) { FactoryBot.create(:album) }

    it 'returns 204' do
      call
      expect(response).to have_http_status(:no_content)
    end

    context 'with invalid id' do
      before { delete '/albums/-1', headers: authenticated_header }

      it 'returns status code 404 and error message' do
        expect(response).to have_http_status(:not_found)
          .and match_json_schema('error/error')
      end
    end
  end

  context 'when unauthenticated' do
    let(:album) { FactoryBot.create(:album) }

    before { delete "/albums/#{album.id}" }

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end
