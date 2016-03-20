class AdminController < ApplicationController

  layout "admin_portal"

  def index

  end

  def categories
    @column_names = Category.column_names
    @categories = Category.all
  end

  def new_category
    @category = Category.new
  end

end
