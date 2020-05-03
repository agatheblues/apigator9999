# frozen_string_literal: true

require 'rails_helper'

describe 'DELETE /albums/:id deletes the album', type: :request do
  subject(:call) { delete "/albums/#{id}", headers: headers }
  let(:album) { FactoryBot.create(:album) }
  let(:id) { album.id }
  let(:headers) { admin_authenticated_header }

  before { call }

  context 'when authenticated and admin' do
    it 'returns 204' do
      expect(response).to have_http_status(:no_content)
    end

    context 'with invalid id' do
      let(:id) { -1 }

      it 'returns status code 404 and error message' do
        expect(response).to have_http_status(:not_found)
          .and match_json_schema('error/error')
      end
    end
  end

  context 'when authenticated but not admin' do
    let(:headers) { authenticated_header }

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end

  context 'when unauthenticated' do
    let(:headers) { nil }

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end
