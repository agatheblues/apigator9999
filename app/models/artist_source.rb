class ArtistSource < ApplicationRecord
  belongs_to :artist
  
  # validations
  validates_presence_of :source_id, :source
end
