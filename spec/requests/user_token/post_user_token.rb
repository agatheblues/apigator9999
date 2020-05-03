# frozen_string_literal: true

require 'rails_helper'

describe 'POST /user_token creates new token', type: :request do
  subject(:call) { post '/user_token', params: params }
  let(:user) { FactoryBot.create(:user, password: 'muchsecret') }

  context 'when user exists' do
    let(:params) do
      {
        "auth": {
          "email": user['email'],
          "password": 'muchsecret'
        }
      }
    end

    it 'creates a new token' do
      call
      expect(response).to have_http_status(:created)
    end
  end

  context 'when user does not exists' do
    let(:params) do
      {
        "auth": {
          "email": 'doesntexist@test.com',
          "password": 'muchsecret'
        }
      }
    end
    it 'does not create a new token' do
      call
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'when password is invalid' do
    let(:params) do
      {
        "auth": {
          "email": user['email'],
          "password": 'wrongpassword'
        }
      }
    end
    it 'does not create a new token' do
      call
      expect(response).to have_http_status(:not_found)
    end
  end
end
