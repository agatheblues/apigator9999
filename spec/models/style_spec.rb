require 'rails_helper'

describe Style, :type => :model do  
  context "associations" do
    it { should have_and_belong_to_many(:albums) }
  end

  context "validations" do
    let(:valid_attrs) { FactoryBot.attributes_for(:style) }    
    let(:no_name_attrs) { FactoryBot.attributes_for(:style, name: nil) }

    it "is valid with valid attributes" do
      expect(Style.new(valid_attrs)).to be_valid
    end

    it "is not valid without a name" do
      expect(Style.new(no_name_attrs)).to_not be_valid
    end
  end
end