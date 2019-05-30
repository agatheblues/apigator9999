# Album describes the album model
class Album < ApplicationRecord
  # model association
  has_and_belongs_to_many :genres, dependent: :destroy
  has_and_belongs_to_many :artists, dependent: :destroy

  # nested attributes
  accepts_nested_attributes_for :artists, :genres

  # validations
  validates_presence_of :name, :added_at, :release_date, :total_tracks,
                        :img_url, :height, :width
  # validates_presence_of :artists, on: :create

  validate :at_least_one_source_exists
  validate :sources_are_unique, on: :create

  def as_json(*)
    super(
      include:
        {
          artists: { except: [:created_at, :updated_at] },
          genres: { except: [:created_at, :updated_at] },
        },
      except: [:created_at, :updated_at])
  end

  private

  def at_least_one_source_exists
    errors.add(:base, "either spotify_id or discogs_id must be present") unless source_is_present
  end

  def sources_are_unique
    errors.add(:base, "this spotify_id already exists in the database") if source_exists("spotify_id")
    errors.add(:base, "this discogs_id already exists in the database") if source_exists("discogs_id")
  end

  def source_exists(source)
    self[source] && Album.exists?(source => self[source])
  end

  def source_is_present
    self[:spotify_id] || self[:discogs_id]
  end
end
