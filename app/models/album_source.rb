class AlbumSource < ApplicationRecord
  belongs_to :album

  # validations
  validates_presence_of :source_id, :source
end
