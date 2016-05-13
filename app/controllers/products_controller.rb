class ProductsController < ApplicationController

  def index
    @products = Product.all_with_category
  end

  def show
    @product = Product.one_product_with_category(params[:id])
    @nb_orders = Order.nb_orders_by_product(params[:id])
    @nb_carts = Order.nb_carts_by_product(params[:id])
  end

end
