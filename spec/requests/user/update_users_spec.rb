# frozen_string_literal: true

require 'rails_helper'

describe 'PATCH /users/:id updates user', type: :request do
  context 'when authenticated as user' do
    let!(:user_params) { FactoryBot.attributes_for(:user) }

    before { patch "/users/#{current_user['id']}", params: user_params, headers: authenticated_header }

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'has the correct schema' do
      expect(response).to match_json_schema('user/user')
    end

    it 'updated the user' do
      expect(json['username']).to eq(user_params[:username])
      expect(json['email']).to eq(user_params[:email])
    end
  end

  context 'when authenticated as another user' do
    let!(:user) { FactoryBot.create(:user) }

    before { patch "/users/#{user['id']}", params: {}, headers: authenticated_header }

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end

  context 'when unauthenticated' do
    before { patch "/users/#{current_user['id']}", params: {} }

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end
