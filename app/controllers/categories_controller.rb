class CategoriesController < ApplicationController
  def index
    @categories = Category.all

    render layout: "admin_portal"
  end
end
