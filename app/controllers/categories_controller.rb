class CategoriesController < ApplicationController
  def index
    @categories = Category.all

    flash.now[:notify] = "Displaying Product Categories.."

    render layout: "admin_portal"
  end
end
