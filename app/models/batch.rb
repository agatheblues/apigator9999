# frozen_string_literal: true

class Batch < ApplicationRecord
  validates :data, presence: true
end
