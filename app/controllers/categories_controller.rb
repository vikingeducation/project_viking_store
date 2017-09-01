class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def show
    @category = Category.find(params[:id])
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(category_form_params)
      redirect_to category_path(@category)
    else
      render :show
    end
  end

  def create
    @category = Category.new(category_form_params)
    if @category.save
      redirect_to category_path(@category)
    else
      render :show
    end
  end

  def category_form_params
    params.require(:category).permit(:name, :description, :created_at, :updated_at)
  end
end
