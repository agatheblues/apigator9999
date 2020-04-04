# frozen_string_literal: true

class ArtistsController < ApplicationController
  before_action :set_artist, only: [:show]

  def index
    @artists = Artist.all.includes(:albums).order('updated_at DESC')
    @total_artists = @artists.count
    @total_albums = @artists.map(&:albums).flatten.uniq(&:id).size
  end

  def show; end

  def merge
    artist1 = Artist.find(params[:id1])
    artist2 = Artist.find(params[:id2])
    @artist = MergeArtists.call(artist1, artist2)
    render :show, status: :ok
  rescue ActiveRecord::RecordInvalid, MergeArtists::ArtistsMergeInvalidError => e
    render json: { status: 'error', code: 4000, message: e.message }, status: :bad_request
  end

  private

  def set_artist
    @artist = Artist.find(params[:id])
  end
end
