class Album < ApplicationRecord
    # model association
    has_and_belongs_to_many :genres
    has_and_belongs_to_many :artists
    has_many :album_sources, dependent: :destroy

    # validations
    validates_presence_of :name, :added_at, :release_date, :total_tracks, :img_url, :height, :width
end
