# frozen_string_literal: true

class Artist < ApplicationRecord
  # model association
  has_and_belongs_to_many :albums
  before_destroy { albums.clear }

  validates :name, presence: true
  validate :at_least_one_id?

  def at_least_one_id?
    errors.add(:spotify_id, 'or Discogs needs a value') unless spotify_id.present? || discogs_id.present?
  end
end
