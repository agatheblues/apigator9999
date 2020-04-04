# frozen_string_literal: true

class AlbumsController < ApplicationController
  before_action :set_album, only: %i[show update destroy]

  def index
    relation = Album.joins(:genres, :styles).includes(:artists, :genres, :styles)
    @albums = FilterAlbums.call(relation, filter_params).order('albums.added_at DESC')
    @total_albums = @albums.count
    @total_artists = @albums.map(&:artists).flatten.uniq(&:id).size
  end

  def show; end

  def create
    @album = CreateAlbum.call(album_params, artists, genres, styles)
    render :show, status: :created
  rescue ActiveRecord::RecordInvalid, CreateOrUpdateArtists::ArtistsMissingError => e
    render json: { status: 'error', code: 4000, message: e.message }, status: :bad_request
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
    params.permit(artists: %i[name img_url spotify_id discogs_id total_tracks total_albums])
  end

  def artists
    return [] unless artist_params.key?(:artists)

    artist_params['artists']
  end

  def genre_params
    params.permit(genres: [:name])
  end

  def genres
    return [] unless genre_params.key?(:genres)

    genre_params['genres']
  end

  def style_params
    params.permit(styles: [:name])
  end

  def styles
    return [] unless style_params.key?(:styles)

    style_params['styles']
  end

  def filter_params
    params.permit(:genres, :styles).to_h
  end
end
