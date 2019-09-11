class Artist < ApplicationRecord
  # model association
  has_and_belongs_to_many :albums

  # nested attributes
  accepts_nested_attributes_for :albums
end
