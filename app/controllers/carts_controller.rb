class CartsController < ApplicationController

  def edit
    @cart = session[:cart]
    @total = 0
  end


  def update
    @cart = session[:cart]
    render :edit
  end


  def create
    session[:cart] ||= {}
    product = params[:product]

    if Product.exists?(product) && session[:cart][product]
      session[:cart][product] += 1
      flash[:success] = "Added one more '#{Product.find(product).name}' to cart."
    elsif Product.exists?(product)
      session[:cart][product] = 1
      flash[:success] = "'#{Product.find(product).name}' added to cart."
    end
    redirect_to products_path   
  end




end
