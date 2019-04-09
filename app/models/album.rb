class Album < ApplicationRecord
  # model association
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :artists
  has_many :album_sources, dependent: :destroy

  # nested attributes
  accepts_nested_attributes_for :artists
  accepts_nested_attributes_for :album_sources

  # validations
  validates_presence_of :name, :added_at, :release_date, :total_tracks, :img_url, :height, :width
  validates_presence_of :album_sources, :artists, :on => :create
end
