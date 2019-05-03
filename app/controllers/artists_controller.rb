class ArtistsController < ApplicationController
  before_action :set_artist, only: [:show, :update, :destroy]

  def index
    @artists = Artist.all
    json_response(@artists)
  end

  def create
    @artist = Artist.new(artist_params)
    if @artist.save
      json_response(@artist, :created)
    else
      json_response({ message: @artist.errors.messages }, :bad_request)
    end
  end

  def show
    json_response(@artist)
  end

  def update
    @artist.update(artist_params)
    if @artist.save
      json_response(message: "Artist successfully updated!")
    else
      json_response({ message: @artist.errors.messages }, :bad_request)
    end
  end

  def destroy
    @artist.destroy
    head :no_content
  end

  private

  def artist_params
    params.permit(
      :name, :img_url, :spotify_id, :discogs_id,
      albums_attributes: [
        :name, :added_at, :release_date, :height, :width,
        :img_url, :total_tracks, :spotify_id, :discogs_id
      ])
  end

  def set_artist
    @artist = Artist.find(params[:id])
  end
end
