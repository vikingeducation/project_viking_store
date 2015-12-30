class Admin::CategoriesController < ApplicationController
  layout 'admin'
  before_action :set_category

  def index
    @categories = Category.all
  end

  def show
  end

  private

  def set_category
    @category = Category.find(params[:id])
    @products = Product.where(category_id: params[:id])
  end
end
