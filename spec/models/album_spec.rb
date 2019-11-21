require 'rails_helper'

describe Album, :type => :model do  
  context "associations" do
    it { should have_and_belong_to_many(:artists) }
    it { should have_and_belong_to_many(:genres) }
    it { should have_and_belong_to_many(:styles) }
  end

  context "validations" do
    setup do
      @valid_attrs = FactoryBot.attributes_for(:album)
      @no_name_attrs = FactoryBot.attributes_for(:album, name: nil)
      @no_added_at_attrs = FactoryBot.attributes_for(:album, added_at: nil)
      @no_id_attrs = FactoryBot.attributes_for(:album, spotify_id: nil, discogs_id: nil)
    end

    it "is valid with valid attributes" do
      expect(Album.new(@valid_attrs)).to be_valid
    end

    it "is not valid without a name" do
      expect(Album.new(@no_name_attrs)).to_not be_valid
    end

    it "is not valid without added_at" do
      expect(Album.new(@no_added_at_attrs)).to_not be_valid
    end

    it "is not valid without at least a discogs or spotify id" do
      expect(Album.new(@no_id_attrs)).to_not be_valid
    end
  end
end