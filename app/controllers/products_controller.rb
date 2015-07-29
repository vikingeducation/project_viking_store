class ProductsController < ApplicationController

  def index
    category = Category.where("id = ?", params[:category_id].to_i).first
    @products = Product.filter_by(category).limit(6)
  end

end
