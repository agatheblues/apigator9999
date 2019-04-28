class GenresController < ApplicationController

  def index
    @genres = Genre.all
    json_response(@genres)
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      json_response(@genre, :created)
    else
      json_response({ message: @genre.errors.messages }, :bad_request)
    end
  end

  def show
    json_response(@genre)
  end

  def update
    @genre.update(genre_params)
    if @genre.save
      head :no_content
    else
      json_response({ message: @genre.errors.messages }, :bad_request)
    end
  end

  def destroy
    @genre.destroy
    head :no_content
  end

  private

  def genre_params
    params.permit(:name, :type)
  end

  def set_genre
    @genre = Genre.find(params[:id])
  end
end
