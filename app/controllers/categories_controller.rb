class CategoriesController < ApplicationController
  layout 'admin_portal_layout'

  def index_categ
    flash[:success] = "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Porro, alias."
    @all_categories = Category.all
    render "/dashboard/index_categ", :locals => {:all_categories => @all_categories }
  end


end
