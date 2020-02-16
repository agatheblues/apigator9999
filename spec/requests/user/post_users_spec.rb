# frozen_string_literal: true

require 'rails_helper'

describe 'POST /users creates new user', type: :request do
  context 'when user is not admin' do
    let!(:user_params) { FactoryBot.attributes_for(:user) }

    it 'creates a new user' do
      expect do
        post '/users', params: user_params
      end.to change(User, :count).by(1)
    end

    it 'returns status code 201' do
      post '/users', params: user_params
      expect(response).to have_http_status(:created)
    end

    it 'has the correct body' do
      post '/users', params: user_params
      expect(json['message']).to eq('User was created.')
    end
  end

  context 'when user tries to be admin' do
    let!(:user_params) { FactoryBot.attributes_for(:user, role: 'admin') }

    it 'creates a new user' do
      expect do
        post '/users', params: user_params
      end.to change(User, :count).by(1)
    end

    it 'returns status code 201' do
      post '/users', params: user_params
      expect(response).to have_http_status(:created)
    end

    it 'has the correct body' do
      post '/users', params: user_params
      expect(json['message']).to eq('User was created.')
    end

    it 'has not created an admin role' do
      post '/users', params: user_params
      user = User.first
      expect(user['role']).to eq('user')
    end
  end
end
