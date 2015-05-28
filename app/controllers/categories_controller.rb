class CategoriesController < ApplicationController
  layout "admin"

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(whitelisted_category_params)
    if @category.save
      flash[:success] = "Category created!"
      redirect_to categories_path
    else
      flash[:error] = "Couldn't create category :("
      render "/categories/new"
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      flash[:success] = "Category obliterated!"
      redirect_to categories_path
    else
      flash[:error] = "Couldn't delete category :("
      render "categories/show"
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(whitelisted_category_params)
      flash[:success] = "Category updated!"
      redirect_to categories_path
    else
      flash[:error] = "Couldn't update category :("
      render "categories/edit"
    end
  end

  def whitelisted_category_params
    params.require(:category).permit(:name, :description)
  end
end
