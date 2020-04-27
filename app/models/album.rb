# frozen_string_literal: true

class Album < ApplicationRecord
  # model association
  has_and_belongs_to_many :artists
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :styles

  before_destroy do
    artists.each do |artist|
      handle_total_tracks(artist)
      handle_total_albums(artist)
    end
    genres.each { |genre| handle_total_albums(genre) }
    styles.each { |style| handle_total_albums(style) }
  end

  validates :added_at, presence: true
  validates :name, presence: true
  validate :at_least_one_id?

  def at_least_one_id?
    errors.add(:spotify_id, 'or Discogs needs a value') unless spotify_id.present? || discogs_id.present?
  end

  private

  def handle_total_albums(association)
    if association.albums.length == 1
      association.destroy
    else
      association.update(total_albums: association.total_albums - 1)
    end
  end

  def handle_total_tracks(association)
    association.update(total_tracks: association.total_tracks - total_tracks)
  end
end
