class ProductsController < ApplicationController
  def index
    filter = params[:products_filter]
    @products = filter.present? ? Product.where("category_id = ?", filter) : Product.all
    if params[:item]
      session[:cart] ||= {}
      item = params[:item]
      if Product.where("id = ?", item).present?
        if session[:cart][item]
          session[:cart][item] += 1
        else
          session[:cart][item] = 1
        end
        flash[:success] = "Item added to cart"
      else
        flash[:error] = "Product is invalid"
      end
      redirect_to products_path
    end
  end

  def show
  end
end
