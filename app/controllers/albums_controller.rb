class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :update, :destroy]

  def index
    @albums = Album.all
    json_response(@albums)
  end

  def create
    @album = Album.new(album_params)
    @album.genres = album_params["genres_attributes"].map { |genre| get_genre(genre) }

    if @album.save
      json_response(@album, :created)
    else
      json_response({ message: @album.errors.messages }, :bad_request)
    end
  end

  def show
    json_response(@album)
  end

  def update
    @album.update(album_params)
    if @album.save
      json_response(message: "ALbum successfully updated!")
    else
      json_response({ message: @album.errors.messages }, :bad_request)
    end
  end

  def destroy
    @album.destroy
    head :no_content
  end

  private

  def album_params
    params.permit(
      :name, :added_at, :release_date, :height, :width, :img_url, :total_tracks,
      :spotify_id, :discogs_id,
      artists_attributes: [:id, :name, :img_url, :spotify_id, :discogs_id],
      genres_attributes: [:category, :name]
    )
  end

  def set_album
    @album = Album.find(params[:id])
  end

  def get_genre(genre)
    Genre.find_by(name: genre["name"], category: genre["category"]) || Genre.new(genre)
  end
end
