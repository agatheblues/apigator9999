# The Artist model
class Artist < ApplicationRecord
  # model association
  has_and_belongs_to_many :albums

  # nested attributes
  accepts_nested_attributes_for :albums

  # validations
  validates_presence_of :name, :img_url

  def as_json(*)
    super(include: { albums: { except: [:created_at, :updated_at] } },
          except: [:created_at, :updated_at])
  end
end
