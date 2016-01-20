class ProductsController < ApplicationController

  def index

    current_user
    category = Category.where("id = ?", params[:category_id].to_i).first
    @products = Product.filter_by(category).limit(6)

    add_product if params[:add_product_id]

  end

  private

  def add_product

    if current_user
      cart = get_or_build_cart
      update_quantity(cart, params[:add_product_id], 1)
      if cart.save
        flash.now[:success] = "Item added to cart!"
      else
        flash.now[:danger] = "Item failed to be added - please try again."
      end

    else
      add_product_to_visitor_cart
    end

  end

  def add_product_to_visitor_cart

    session[:visitor_cart] ||= {}

    if session[:visitor_cart].include?(params[:add_product_id])
      session[:visitor_cart][params[:add_product_id]] += 1
    else
      session[:visitor_cart][params[:add_product_id]] = 1
    end

    flash_visitor_result

  end

  def flash_visitor_result

    if session[:visitor_cart].include?(params[:add_product_id])
      flash[:success] = "Item added to cart!"
    else
      flash[:danger] = "Item failed to be added to cart - please try again."
    end

  end
  
end
