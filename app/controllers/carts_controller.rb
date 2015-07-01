class CartsController < ApplicationController
  include CartsHelper

  def create
    session[:cart] || session[:cart] = {}
    item = params[:item]

    if Product.exists?(item) && session[:cart][item]
      session[:cart][item] += 1
      flash[:success] = "Added another #{Product.find(item).name} to cart! "
    elsif Product.exists?(item)
      session[:cart][item] = 1
      flash[:success] = "#{Product.find(item).name} added to cart!"
    end
    redirect_to root_path
  end

  def update
    @cart = session[:cart]

    params[:updated].each do |product_id, quantity|
      session[:cart][product_id] = quantity.to_i
      session[:cart].delete(product_id) if quantity == "0" || quantity == ""
    end

    if params[:deleted]
      params[:deleted].each do |product_id, _quantity|
        session[:cart].delete(product_id)
      end
    end
    flash[:success] = "Cart updated successfully!"
    redirect_to edit_cart_path
  end

  def edit
    @products = session[:cart]
    # @products = User.find(current_user.id).orders.where("checkout_date IS NULL").first.products
    @total = total
  end
end
