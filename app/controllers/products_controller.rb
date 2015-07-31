class ProductsController < ApplicationController
  def index
    session[:cart] ||= []
    @cart = session[:cart]

    @selected = get_selected
    if @selected
      @products = Category.find(@selected).products
    else
      @products = Product.all
    end
  end

  private
    def get_selected
      if params[:category] && !params[:category][:id].empty?
        params[:category][:id]
      end
    end
end
