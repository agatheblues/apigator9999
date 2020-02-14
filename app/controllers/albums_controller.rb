class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :update, :destroy]

  def index
    @albums = FilterAlbums.call(Album.all, filter_params).order('added_at DESC')
    @total_albums = @albums.count
    @total_artists = @albums.map { |album| album.artists }.flatten.uniq { |artist| artist.id }.size
  end

  def show; end

  def create
    @album = CreateAlbum.call(album_params, artists, genres, styles)
    render :show, status: :created
  rescue ActiveRecord::RecordInvalid, CreateOrUpdateArtists::ArtistsMissingError => e
    render json: {status: "error", code: 4000, message: e.message}, status: :bad_request
  end

  def update
    @album = UpdateAlbum.call(@album, album_params, artists, genres, styles)
    render :show, status: :ok
  end
  
  def destroy
    @album.destroy
  end

  private

  def set_album
    @album = Album.find(params[:id])
  end

  def album_params
    params.permit(:name, :release_date, :added_at, :total_tracks, :img_url, :img_width, 
      :img_height, :spotify_id, :discogs_id)
  end

  def artist_params
    params.permit(:artists => [:name, :img_url, :spotify_id, :discogs_id, :total_tracks, :total_albums])
  end

  def artists
    return [] if !artist_params.has_key?(:artists)
    artist_params['artists']
  end

  def genre_params
    params.permit(:genres => [:name])  
  end

  def genres
    return [] if !genre_params.has_key?(:genres)
    genre_params['genres']
  end

  def style_params
    params.permit(:styles => [:name])
  end

  def styles
    return [] if !style_params.has_key?(:styles)
    style_params['styles']
  end

  def filter_params
    params.permit(:genres, :styles).to_h
  end
end
