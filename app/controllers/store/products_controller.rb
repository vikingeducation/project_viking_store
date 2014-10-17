class Store::ProductsController < ApplicationController

  def index
    if params[:category]
      @category = Category.find(params[:category][:id])
      @products = Product.containing_only_category(@category)
    else
      @products = Product.all
    end
  end

  def update
    @product_id = params[:id]
    session[:cart] ||= Hash.new(0)

    if Product.exists?(@product_id) && session[:cart][@product_id]
      session[:cart][@product_id] += 1
      flash[:success] = "Added another to your cart."
    elsif Product.exists?(@product_id)
      session[:cart][@product_id] = 1
      flash[:success] = "Added new item to your cart."
    else
      flash[:error] = "Item requested doesn't seem to exist. Sorry!"
    end

    redirect_to action: :index
  end

end
