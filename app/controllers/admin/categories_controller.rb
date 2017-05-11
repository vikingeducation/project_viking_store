class Admin::CategoriesController < ApplicationController

  layout "admin"

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def show
  end

end
