# frozen_string_literal: true

class ArtistsController < ApplicationController
  before_action :set_artist, only: [:show]

  def index
    @artists = Artist.all.order('updated_at DESC')
    @total_artists = @artists.count
    @total_albums = @artists.map(&:albums).flatten.uniq(&:id).size
  end

  def show; end

  private

  def set_artist
    @artist = Artist.find(params[:id])
  end
end
