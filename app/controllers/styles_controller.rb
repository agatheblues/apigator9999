class StylesController < ApplicationController
  def index
    @styles = Style.all.order('name ASC')
  end
end
