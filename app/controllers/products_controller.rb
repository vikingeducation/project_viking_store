class ProductsController < ApplicationController

  layout 'front_facing'

  def index
    @category_options = Category.all.map{|u| [u.name,u.id]}
    params[:category_id] ? @products = Product.where(:category_id => params[:category_id]) : @products = Product.all
    @selected_option = params[:category_id] if params[:category_id]
  end
end
