# frozen_string_literal: true

require 'rails_helper'

describe Genre, type: :model do
  context 'associations' do
    it { should have_and_belong_to_many(:albums) }
  end

  context 'validations' do
    let(:valid_attrs) { FactoryBot.attributes_for(:genre) }
    let(:no_name_attrs) { FactoryBot.attributes_for(:genre, name: nil) }

    it 'is valid with valid attributes' do
      expect(Genre.new(valid_attrs)).to be_valid
    end

    it 'is not valid without a name' do
      expect(Genre.new(no_name_attrs)).to_not be_valid
    end
  end
end
