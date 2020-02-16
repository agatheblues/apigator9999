# frozen_string_literal: true

class UpdateAlbum
  def self.call(*args)
    new(*args).call
  end

  def call
    ActiveRecord::Base.transaction do
      @album.update(@album_params)
      @album.artists = CreateOrUpdateArtists.call(@artists, @album_params['total_tracks'].to_i) unless @artists.empty?
      @album.genres = CreateOrUpdateGenres.call(@genres) unless @genres.empty?
      @album.styles = CreateOrUpdateStyles.call(@styles) unless @styles.empty?
      @album
    end
  end

  private

  def initialize(album, album_params, artists, genres, styles)
    @album = album
    @album_params = album_params
    @artists = artists
    @genres = genres
    @styles = styles
  end
end
