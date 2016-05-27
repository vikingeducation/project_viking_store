class ProductsController < ApplicationController
  layout "shop"

  def index
    category_id = params[:filter_category].to_i
    if Category.ids.include?(category_id)
      @products = Product.where(category_id: category_id)
      @filter_category = Category.find(category_id).name
    else
      @products = Product.all
      @filter_category = "Choose a Category"
    end

  end
end
