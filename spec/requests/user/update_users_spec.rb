# frozen_string_literal: true

require 'rails_helper'

describe 'PATCH /users/:id updates user', type: :request do
  subject(:call) { patch "/users/#{user['id']}", params: params, headers: headers }
  let(:headers) { admin_authenticated_header }
  let(:user) { FactoryBot.create(:user, confirmed_at: nil) }
  let(:params) { FactoryBot.attributes_for(:user) }

  context 'when authenticated as admin' do
    let(:user_params) { user.attributes }

    it 'returns status code 200' do
      call
      expect(response).to have_http_status(:ok)
      expect(response).to match_json_schema('user/user')
      expect(user.reload).to have_attributes(
        {
          username: user_params['username'],
          email: user_params['email'],
          role: user_params['role']
        }
      )
      expect(user.confirmed_at).to be_within(1.second).of(params[:confirmed_at])
    end
  end

  context 'when authenticated as another user' do
    let(:headers) { authenticated_header }
    let(:params) { {} }

    it 'returns unauthorized' do
      call
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end

  context 'when unauthenticated' do
    let(:headers) { nil }
    let(:params) { {} }

    it 'returns unauthorized' do
      call
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end
