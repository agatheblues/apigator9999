# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  context 'validations' do
    let(:valid_attrs) { FactoryBot.attributes_for(:user) }
    let(:no_name_attrs) { FactoryBot.attributes_for(:user, username: nil) }
    let(:no_email_attrs) { FactoryBot.attributes_for(:user, email: nil) }
    let(:no_password_attrs) { FactoryBot.attributes_for(:user, password: nil) }
    let(:short_password) { FactoryBot.attributes_for(:user, password: 'passwrd') }
    let(:long_password) { FactoryBot.attributes_for(:user, password: 'password' * 9 + 'a') }

    it 'is valid with valid attributes' do
      expect(User.new(valid_attrs)).to be_valid
    end

    it 'is not valid without a username' do
      expect(User.new(no_name_attrs)).to_not be_valid
    end

    it 'is not valid without an email' do
      expect(User.new(no_email_attrs)).to_not be_valid
    end

    it 'is not valid without a password' do
      expect(User.new(no_password_attrs)).to_not be_valid
    end

    it 'is not valid with a short password' do
      expect(User.new(short_password)).to_not be_valid
    end

    it 'is not valid with a long password' do
      expect(User.new(long_password)).to_not be_valid
    end
  end

  context 'uniqueness' do
    let(:user) { FactoryBot.create(:user) }
    let(:same_username) { FactoryBot.attributes_for(:user, username: user.username) }
    let(:same_email) { FactoryBot.attributes_for(:user, email: user.email) }

    it 'is not valid if username already exists' do
      expect(User.new(same_username)).to_not be_valid
    end

    it 'is not valid if email already exists' do
      expect(User.new(same_email)).to_not be_valid
    end
  end

  context 'when user' do
    let(:user) { FactoryBot.create(:user) }

    it 'admin? return false' do
      expect(user.admin?).to be false
    end
  end

  context 'when admin' do
    let(:admin) { FactoryBot.create(:user, role: 'admin') }

    it 'admin? return true' do
      expect(admin.admin?).to be true
    end
  end
end
