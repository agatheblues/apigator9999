# frozen_string_literal: true

class CreateOrUpdateGenres
  def self.call(*args)
    new(*args).call
  end

  def call
    ActiveRecord::Base.transaction do
      @genres.map do |genre_params|
        existing_genre = Genre.find_by(name: genre_params['name'])
        if existing_genre.nil?
          create_genre(genre_params)
        else
          update_genre(existing_genre, genre_params)
        end
      end
    end
  end

  private

  def initialize(genres)
    @genres = genres
  end

  def get_total_albums(current_albums)
    current_albums + 1
  end

  def create_genre(attrs)
    attrs = attrs.merge('total_albums' => get_total_albums(0))
    Genre.create!(attrs)
  end

  def update_genre(existing_genre, attrs)
    attrs = attrs.merge('total_albums' => get_total_albums(existing_genre['total_albums']))
    existing_genre.update(attrs)
    existing_genre
  end
end
