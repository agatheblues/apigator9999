class Genre < ApplicationRecord
  # model association
  has_and_belongs_to_many :genres

  validates :name, presence: true
end
