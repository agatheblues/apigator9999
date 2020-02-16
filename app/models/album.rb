# frozen_string_literal: true

class Album < ApplicationRecord
  # model association
  has_and_belongs_to_many :artists
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :styles

  before_destroy do
    artists.each { |artist| handle_association(artist) }
    genres.each { |genre| handle_association(genre) }
    styles.each { |style| handle_association(style) }
  end

  validates :added_at, presence: true
  validates :name, presence: true
  validate :at_least_one_id?

  def at_least_one_id?
    errors.add(:spotify_id, 'or Discogs needs a value') unless spotify_id.present? || discogs_id.present?
  end

  private

  def handle_association(association)
    if association.albums.length == 1
      association.destroy
    else
      association.update(total_albums: association.total_albums - 1)
    end
  end
end
