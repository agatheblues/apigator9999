# frozen_string_literal: true

require 'rails_helper'

describe 'DELETE /users/:id deletes user', type: :request do
  subject(:call) { delete "/users/#{user['id']}", headers: headers }
  let(:headers) { admin_authenticated_header }
  let(:user) { FactoryBot.create(:user) }

  context 'when authenticated as admin' do
    before do
      admin_current_user
      user
    end

    it 'deletes the user and returns 204' do
      expect { call }.to change(User, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end

  context 'when authenticated as user' do
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
