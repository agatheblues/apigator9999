# frozen_string_literal: true

require 'rails_helper'

describe Artist, type: :model do
  context 'associations' do
    it { should have_and_belong_to_many(:albums) }
  end

  context 'validations' do
    let(:valid_attrs) { FactoryBot.attributes_for(:artist) }
    let(:no_name_attrs) { FactoryBot.attributes_for(:artist, name: nil) }
    let(:no_id_attrs) { FactoryBot.attributes_for(:artist, spotify_id: nil, discogs_id: nil) }

    it 'is valid with valid attributes' do
      expect(Artist.new(valid_attrs)).to be_valid
    end

    it 'is not valid without a name' do
      expect(Artist.new(no_name_attrs)).to_not be_valid
    end

    it 'is not valid without at least a discogs or spotify id' do
      expect(Artist.new(no_id_attrs)).to_not be_valid
    end
  end
end
