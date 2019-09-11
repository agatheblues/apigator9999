class Album < ApplicationRecord
  # model association
  has_and_belongs_to_many :artists

  # nested attributes
  accepts_nested_attributes_for :artists
end
