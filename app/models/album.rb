class Album < ApplicationRecord
  # model association
  has_and_belongs_to_many :artists
  has_and_belongs_to_many :genres
  before_destroy do
    artists.each { |artist| artist.destroy if artist.albums.length == 1 }
  end
  before_destroy do
    genres.each { |genre| genre.destroy if genre.albums.length == 1 }
  end

  validates :added_at, presence: true
  validates :name, presence: true
  validate :has_at_least_one_id
  
  validates_associated :artists

  def has_at_least_one_id
    errors.add(:spotify_id, "or Discogs needs a value") unless spotify_id.present? || discogs_id.present?
  end
end