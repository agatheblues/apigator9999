# frozen_string_literal: true

require 'rails_helper'

describe 'DELETE /users/:id deletes user', type: :request do
  context 'when authenticated as user' do
    it 'deletes the user' do
      current_user
      expect do
        delete "/users/#{current_user['id']}", headers: authenticated_header
      end.to change(User, :count).by(-1)
    end

    it 'returns status code 204' do
      delete "/users/#{current_user['id']}", headers: authenticated_header
      expect(response).to have_http_status(:no_content)
    end
  end

  context 'when authenticated as another user' do
    let!(:user) { FactoryBot.create(:user) }

    before { delete "/users/#{user['id']}", headers: authenticated_header }

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end

  context 'when unauthenticated' do
    before { delete "/users/#{current_user['id']}" }

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end
