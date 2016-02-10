class CartsController < ApplicationController

  def edit
    @cart = session[:cart]
  end


  def update
    @cart = session[:cart]
  end


  def create
    session[:cart] ||= {}
    product = params[:product]

    if Product.exists?(product) && session[:cart][product]
      session[:cart][product] += 1
      flash[:success] = "Added one more #{Product.find(product).name} to cart."
    elsif Product.exists?(product)
      session[:cart][product] = 1
      flash[:success] = "#{Product.find(product).name} added to cart."
    end
    render :edit    
  end




end
