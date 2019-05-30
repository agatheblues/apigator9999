# The Genre model
class Genre < ApplicationRecord
  # model associations
  has_and_belongs_to_many :albums, dependent: :destroy

  # Scope
  default_scope { joins(:albums).distinct.select('genres.*, COUNT(albums.*) AS albums_count').group('genre.id').where('album_count > 0') }

  # Validations
  validates_presence_of :name, :category
  validates_uniqueness_of :name, scope: :category

  def as_json(options = { expand: false })
    if options[:expand]
      super(include: { albums: { except: [:created_at, :updated_at] } },
            except: [:created_at, :updated_at])
    else
      super(except: [:created_at, :updated_at])
    end
  end
end
