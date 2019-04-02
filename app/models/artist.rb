class Artist < ApplicationRecord
  # model association
  has_many :artist_sources, dependent: :destroy
  has_and_belongs_to_many :albums
  
  # validations
  validates_presence_of :name, :img_url
end
