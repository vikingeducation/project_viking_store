class ProductsController < ApplicationController
  layout "shop"

  def index
    category_id = params[:filter_category].to_i || session[:filter_category]
    if Category.ids.include?(category_id)
      @products = Product.where(category_id: category_id)
      @filter_category = Category.find(category_id).name
      session[:filter_category] = category_id
    else
      @products = Product.all
      @filter_category = "Choose a Category"
    end

  end

  def add_product
    session[:cart] = {} if session[:cart].nil?
    product_id = params[:id]

    if session[:cart][product_id].nil?
      session[:cart][product_id] = 1
    else
      session[:cart][product_id] += 1
    end
    flash[:success]= "You Added the #{Product.find(product_id).name} to your cart"
    redirect_to products_path
  end
end
