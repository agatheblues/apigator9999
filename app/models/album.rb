class Album < ApplicationRecord
  # model association
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :artists

  # nested attributes
  accepts_nested_attributes_for :artists

  # validations
  validates_presence_of :name, :added_at, :release_date, :total_tracks, :img_url, :height, :width
  # validates_presence_of :artists, :on => :create

  validate :at_least_one_source_exists

  private 

  def at_least_one_source_exists
    if (!self[:spotify_id].present? && !self[:discogs_id].present?) 
      errors.add(:base, "either spotify_id or discogs_id must be present")
    end
  end

end
