class ProductsController < ApplicationController
  def index
    @products = Product.all.order(:name)
    @product_categories = {}
    @products.each do |product|
      @product_categories[product.id.to_s] = Category.category_name(product)
    end

    render layout: "admin_portal"
  end

  def new
  end
end
