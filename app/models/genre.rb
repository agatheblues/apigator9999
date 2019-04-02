class Genre < ApplicationRecord
  # model associations
  has_and_belongs_to_many :albums
  
  # Validations
  validates_presence_of  :name, :type
end
