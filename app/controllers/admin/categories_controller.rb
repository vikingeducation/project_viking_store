class Admin::CategoriesController < ApplicationController
  layout 'admin'
  before_action :set_category, only: [:show, :edit, :update, :destroy]

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

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_url, notice: 'Category successfully updated!'
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      redirect_to admin_categories_url, notice: 'Category successfully deleted.'
    else
      redirect_to :back, alert: 'Unable to delete category.'
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
    @products = @category.products
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
