# frozen_string_literal: true

class User < ApplicationRecord
  # Necessary to authenticate.
  has_secure_password

  # Basic password validation, configure to your liking.
  validates :password, length: { maximum: 72, minimum: 8, allow_nil: true, allow_blank: false }
  validates :password, confirmation: { allow_nil: true, allow_blank: false }

  before_validation do
    (self.email = email.to_s.downcase) && (self.username = username.to_s.downcase)
  end

  # Make sure email and username are present and unique.
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true

  def admin?
    role == 'admin'
  end

  def confirmed?
    !confirmed_at.nil?
  end
end
