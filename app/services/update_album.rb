class UpdateAlbum
  def self.call(*args)
    new(*args).call
  end

  def call
    ActiveRecord::Base.transaction do
      @album.update(@album_params)
      @album.artists = CreateOrUpdateArtists.call(@artists, @album_params['total_tracks'].to_i) if @artists.length != 0
      @album.genres = CreateOrUpdateGenres.call(@genres) if @genres.length != 0
      @album.styles = CreateOrUpdateStyles.call(@styles) if @styles.length != 0
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