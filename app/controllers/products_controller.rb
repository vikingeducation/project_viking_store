class ProductsController < ApplicationController

  def index
    category = Category.where("id = ?", params[:category_id].to_i).first
    @products = Product.filter_by(category).limit(6)

    add_product_to_visitor_cart if params[:add_product_id]
  end


  private


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
      flash[:danger] = "Item not added.  Please try again."
    end
  end

end
