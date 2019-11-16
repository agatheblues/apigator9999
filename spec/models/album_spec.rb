require 'rails_helper'

describe "album model", :type => :model do  
  let!(:valid_attrs) { FactoryBot.attributes_for(:album) }
  let!(:no_name_attrs) { FactoryBot.attributes_for(:album) }
  let!(:no_added_at_attrs) { FactoryBot.attributes_for(:album) }
  let!(:no_id_attrs) { FactoryBot.attributes_for(:album) }

  it "is valid with valid attributes" do
    expect(Album.new(valid_attrs)).to be_valid
  end

  it "is not valid without a name" do
    no_name_attrs['name'] = nil
    expect(Album.new(no_name_attrs)).to_not be_valid
  end

  it "is not valid without added_at" do
    no_added_at_attrs['added_at'] = nil
    expect(Album.new(no_added_at_attrs)).to_not be_valid
  end

  it "is not valid without at least a discogs or spotify id" do
    no_id_attrs['spotify_id'] = nil
    no_id_attrs['discogs_id'] = nil
    expect(Album.new(no_id_attrs)).to_not be_valid
  end
end