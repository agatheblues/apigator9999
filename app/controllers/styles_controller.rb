class StylesController < ApplicationController
  def index
    @styles = Style.all.order('total_albums DESC')
  end
end
