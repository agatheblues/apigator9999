class AlbumSource < ApplicationRecord
  # validations
  validates_presence_of :source_id, :source
end
