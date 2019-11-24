class Style < ApplicationRecord
  # model association
  has_and_belongs_to_many :albums

  validates :name, presence: true
end
