class ProductsController < ApplicationController
  layout "shop"

  def index
    category_id = params[:filter_category].to_i
    if Category.ids.include?(category_id)
      @products = Product.where(category_id: category_id)
      @filter_category = Category.find(category_id).name
    else
      @products = Product.all
      @filter_category = "Choose a Category"
    end

  end

  def add_product
    session[:user_cart] = {} if session[:user_cart].nil?
    if session[:user_cart][params[:id]].nil?
      session[:user_cart][params[:id]] = 1
    else
      session[:user_cart][params[:id]] += 1
    end
    flash[:success]= "You Added the #{Product.find(params[:id]).name} to your cart"
    redirect_to products_path
  end
end
