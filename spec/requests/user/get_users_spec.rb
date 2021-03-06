# frozen_string_literal: true

require 'rails_helper'

describe 'GET /users/current gets current user', type: :request do
  context 'when authenticated' do
    before { get '/users/current', headers: authenticated_header }

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'has the correct schema' do
      expect(response).to match_json_schema('user/user')
    end

    it 'returns correct user' do
      expect(json['username']).to eq(current_user['username'])
    end
  end

  context 'when unauthenticated' do
    before { get '/users/current' }

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end

describe 'GET /users gets all users', type: :request do
  context 'when authenticated' do
    before { get '/users', headers: admin_authenticated_header }

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
      expect(response).to match_json_schema('user/users')
    end
  end

  context 'when authenticated but not admin' do
    before { get '/users', headers: authenticated_header }

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end

  context 'when unauthenticated' do
    before { get '/users' }

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end
