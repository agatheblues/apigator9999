# frozen_string_literal: true

require 'rails_helper'

describe 'POST /users creates new user', type: :request do
  subject(:call) { post '/users', params: user_params }

  context 'when user is not admin' do
    let!(:user_params) { FactoryBot.attributes_for(:user) }

    it 'creates a new user' do
      expect { call }.to change(User, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json['message']).to eq('User was created.')
    end
  end

  context 'when user tries to be admin' do
    let!(:user_params) { FactoryBot.attributes_for(:user, role: 'admin') }

    it 'creates a new user' do
      expect { call }.to change(User, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json['message']).to eq('User was created.')
    end

    it 'has not created an admin role' do
      call
      user = User.last
      expect(user['role']).to eq('user')
    end
  end

  context 'when email or username already exists' do
    let(:user) { FactoryBot.create(:user) }
    let(:user_params) { user.attributes }

    it 'returns 400' do
      call
      expect(response).to have_http_status(:bad_request)
    end
  end
end
