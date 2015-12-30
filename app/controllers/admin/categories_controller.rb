class Admin::CategoriesController < ApplicationController
  layout 'admin'
  before_action :set_category, only: [:show, :edit, :update, :delete]

  def index
    @categories = Category.all
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to admin_categories_url, notice: 'Category successfully created!'
    else
      render :new
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
    @products = Product.where(category_id: params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
