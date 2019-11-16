require 'rails_helper'

describe "artist model", :type => :model do  
  let!(:valid_attrs) { FactoryBot.attributes_for(:artist) }
  let!(:no_name_attrs) { FactoryBot.attributes_for(:artist) }
  let!(:no_id_attrs) { FactoryBot.attributes_for(:artist) }

  it "is valid with valid attributes" do
    expect(Artist.new(valid_attrs)).to be_valid
  end

  it "is not valid without a name" do
    no_name_attrs['name'] = nil
    expect(Artist.new(no_name_attrs)).to_not be_valid
  end

  it "is not valid without at least a discogs or spotify id" do
    no_id_attrs['spotify_id'] = nil
    no_id_attrs['discogs_id'] = nil
    expect(Artist.new(no_id_attrs)).to_not be_valid
  end
end