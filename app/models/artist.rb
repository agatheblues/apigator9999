class Artist < ApplicationRecord
  # model association
  has_and_belongs_to_many :albums

  validates :name, presence: true
  validate :has_at_least_one_id
  
  def has_at_least_one_id
    errors.add(:spotify_id, "or Discogs needs a value") unless spotify_id.present? || discogs_id.present?
  end
end
