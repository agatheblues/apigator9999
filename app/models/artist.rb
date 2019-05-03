# The Artist model
class Artist < ApplicationRecord
  # model association
  has_and_belongs_to_many :albums

  # nested attributes
  accepts_nested_attributes_for :albums

  # validations
  validates_presence_of :name, :img_url
  # validates_presence_of :albums, on: :create

  validate :at_least_one_source_is_present
  validate :sources_are_unique, on: :create

  before_destroy { albums.clear }

  def as_json(*)
    super(include: { albums: { except: [:created_at, :updated_at] } },
          except: [:created_at, :updated_at])
  end

  private

  def at_least_one_source_is_present
    errors.add(:base, "either spotify_id or discogs_id must be present") unless source_is_present
  end

  def sources_are_unique
    errors.add(:base, "this spotify_id already exists in the database") if source_exists("spotify_id")
    errors.add(:base, "this discogs_id already exists in the database") if source_exists("discogs_id")
  end

  def source_exists(source)
    self[source] && Artist.exists?(source => self[source])
  end

  def source_is_present
    self[:spotify_id] || self[:discogs_id]
  end
end
