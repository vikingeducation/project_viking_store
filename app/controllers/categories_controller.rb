class CategoriesController < ApplicationController
  layout 'admin'

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def show
    @category = Category.find(params[:id])
    @products = Product.where("category_id = ?", @category.id)
  end
end
