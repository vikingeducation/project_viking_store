class CategoriesController < ApplicationController

  def index
    @categories = Category.all
    render layout: "admin"
  end
end
