class Admin::ProductsController < ApplicationController
  layout 'admin_portal_layout'

  def index
    @products = Product.all
    # render "/admin/products/index", :locals => {:products => @products }
  end

  def show
    @product = Product.find(params[:id])
    @product_times_ordered = Product.times_ordered(params[:id])
    @product_times_in_carts = Product.times_in_carts(params[:id])
  end






end
