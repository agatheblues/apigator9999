# frozen_string_literal: true

class Genre < ApplicationRecord
  # model association
  has_and_belongs_to_many :albums

  validates :name, presence: true
end
