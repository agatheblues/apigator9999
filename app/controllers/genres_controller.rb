class GenresController < ApplicationController
  def index
    @genres = Genre.all.order('name ASC')
  end
end
