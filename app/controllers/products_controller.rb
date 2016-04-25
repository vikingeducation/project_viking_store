class ProductsController < ApplicationController

  layout 'front_facing'

  def index
    @category_options = Category.all.map{|u| [u.name,u.id]}
    @products = products

    @selected_option = current_category

    @shopping_cart = shopping_cart
  end

  private

  # if there's a params category_id then it means it's been freshly chosen so should be the selected option.
  # it also means we should update the session[:category_id]
  # If there's no params[:category_id], we should stick with the previous sessing, which will be in the params.
  def current_category
    if params[:category_id]
      session[:category_id] = params[:category_id]
      params[:category_id]
    elsif session[:category_id]
      session[:category_id]
    else
      nil
    end
  end

  # Need to filter products by category.
  # If there's a selected category_id then we're going to choose only those products under that category, otherwise we're sending in all products.
  def products
    if params[:category_id]
      Product.where(:category_id => params[:category_id])
    else
      Product.all
    end
  end

  # if there's no current cart, I want to build a new order.
  def shopping_cart
    session[:shopping_cart] ||= Order.new
  end
end
