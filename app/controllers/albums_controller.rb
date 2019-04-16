class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :update, :destroy]
  
  def index
    @albums = Album.all
    json_response(@albums)
  end

  def create
    @album = Album.create!(album_params)
    if @album.save
      json_response({:album => @album, :artists => @album.artists}, :created)
    else
      puts "OUI"
      json_response(@album.errors[:base], :bad_request)
    end
  end

  def show
    json_response(@album)
  end

  def update
    @album.update(album_params)
    head :no_content
  end

  def destroy
    @album.destroy
    head :no_content
  end

  private

  def album_params
    params.permit(
      :name, :added_at, :release_date, :height, :width, :img_url, :total_tracks, :spotify_id, :discogs_id,
      artists_attributes: [:id, :name, :img_url, :spotify_id, :discogs_id]
    ) 
  end

  def set_album
    @album = Album.find(params[:id])
  end

  def album_source_exists(source_id, source_name)
    AlbumSource.exists?("#{source_name}_id" => source_id)
  end
end

