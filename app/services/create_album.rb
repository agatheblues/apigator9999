# frozen_string_literal: true

class CreateAlbum
  def self.call(*args)
    new(*args).call
  end

  def call
    ActiveRecord::Base.transaction do
      album = Album.create!(@album_params)
      album.artists = CreateOrUpdateArtists.call(@artists, @album_params['total_tracks'].to_i)
      album.genres = CreateOrUpdateGenres.call(@genres)
      album.styles = CreateOrUpdateStyles.call(@styles)
      album
    end
  end

  private

  def initialize(album_params, artists, genres, styles)
    @album_params = album_params
    @artists = artists
    @genres = genres
    @styles = styles
  end
end
