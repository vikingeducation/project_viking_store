class Admin::ProductsController < ApplicationController
  layout 'admin_portal_layout'

  def index
    @products = Product.all
    render "/admin/products/index", :locals => {:products => @products }
  end
end
