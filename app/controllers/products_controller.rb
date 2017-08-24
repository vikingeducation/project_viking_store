class ProductsController < ApplicationController
  before_action :find_product, only: [:show]

  def index
    @products = Product.all.order(:name)
    @product_categories = {}
    @products.each do |product|
      @product_categories[product.id.to_s] = Category.category_name(product)
    end

    render layout: "admin_portal"
  end

  def show
    @product_category = Product.category_name(@product)
    @in_num_orders = Product.in_num_orders(@product)
    @in_num_shopping_carts = Product.in_num_shopping_carts(@product)

    render layout: "admin_portal"
  end

  def new
  end

  private

  def find_product
    @product = Product.find(params[:id])
  end
end
