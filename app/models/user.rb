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
  validates     :email, presence: true
  validates     :username, presence: true
  validates   :email, uniqueness: true
  validates   :username, uniqueness: true

  def can_modify_user?(user_id)
    role == 'admin' || id.to_s == user_id.to_s
  end

  def admin?
    role == 'admin'
  end
end
