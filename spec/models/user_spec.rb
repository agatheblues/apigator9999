require 'rails_helper'

describe User, type: :model do
  context "validations" do
    setup do
      @valid_attrs = FactoryBot.attributes_for(:user)
      @no_name_attrs = FactoryBot.attributes_for(:user, username: nil)
      @no_email_attrs = FactoryBot.attributes_for(:user, email: nil)
      @no_password_attrs = FactoryBot.attributes_for(:user, password: nil)
      @short_password = FactoryBot.attributes_for(:user, password: "passwrd")
      @long_password = FactoryBot.attributes_for(:user, password: "password" * 9 + "a")
    end

    it "is valid with valid attributes" do
      expect(User.new(@valid_attrs)).to be_valid
    end

    it "is not valid without a username" do
      expect(User.new(@no_name_attrs)).to_not be_valid
    end

    it "is not valid without an email" do
      expect(User.new(@no_email_attrs)).to_not be_valid
    end

    it "is not valid without a password" do
      expect(User.new(@no_password_attrs)).to_not be_valid
    end

    it "is not valid with a short password" do
      expect(User.new(@short_password)).to_not be_valid
    end

    it "is not valid with a long password" do
      expect(User.new(@long_password)).to_not be_valid
    end
  end

  context "uniqueness" do
    setup do
      @user = FactoryBot.create(:user)
      @same_username = FactoryBot.attributes_for(:user, username: @user.username)
      @same_email = FactoryBot.attributes_for(:user, email: @user.email)
    end

    it "is not valid if username already exists" do
      expect(User.new(@same_username)).to_not be_valid
    end

    it "is not valid if email already exists" do
      expect(User.new(@same_email)).to_not be_valid
    end
  end

  context "when user" do
    setup do
      @user = FactoryBot.create(:user)
    end

    it "is_admin? return false" do
      expect(@user.is_admin?).to be false
    end

    it "can_modify_user?" do
      expect(@user.can_modify_user?("not_you")).to be false
      expect(@user.can_modify_user?(@user.id)).to be true
    end
  end

  context "when admin" do
    setup do
      @admin = FactoryBot.create(:user, role: "admin")
    end

    it "is_admin? return true" do
      expect(@admin.is_admin?).to be true
    end

    it "can_modify_user?" do
      expect(@admin.can_modify_user?("anyone")).to be true
    end
  end
end
