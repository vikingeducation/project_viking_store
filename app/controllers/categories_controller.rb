class CategoriesController < ApplicationController

  def index
    @categories = Category.all
    render layout: "admin"
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new whitelisted_category_params
    if @category.save
      flash[:success] = "You created a new category."
      redirect_to categories_path
    else
      flash[:error] = "There was an error."
      render :new
    end
  end

  def show
    @category = Category.find params[:id]
  end

  def edit
    @category = Category.find params[:id]
  end

  def update
    @category = Category.find params[:id]
    if @category.update whitelisted_category_params
      flash[:success] = "You successfully updated the category."
      redirect_to categories_path
    else
      flash[:error] = "There's an error."
      render :edit
    end
  end

  private

  def whitelisted_category_params
    params.require(:category).permit(:name,:description)
  end
end
