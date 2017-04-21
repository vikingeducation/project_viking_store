class CategoriesController < ApplicationController
  layout 'admin_portal_layout'

  def index_categ
    flash[:success] = "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Porro, alias."
    render "/dashboard/index_categ"
  end


end
