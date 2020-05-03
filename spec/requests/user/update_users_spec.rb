# frozen_string_literal: true

require 'rails_helper'

describe 'PATCH /users/:id updates user', type: :request do
  subject(:call) { patch "/users/#{user['id']}", params: params, headers: headers }
  let(:headers) { admin_authenticated_header }
  let(:user) { FactoryBot.create(:user) }
  let(:params) { FactoryBot.attributes_for(:user) }

  context 'when authenticated as admin' do
    it 'returns status code 200' do
      call
      expect(response).to have_http_status(:ok)
      expect(response).to match_json_schema('user/user')
    end

    it 'updated the user' do
      call
      expect(json['username']).to eq(params[:username])
      expect(json['email']).to eq(params[:email])
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
