class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(whitelisted_params)
    if @category.save
      flash[:success] = "You just add a new Category named #{@category.name.titleize}"
      redirect_to categories_path
    else
      flash.now[:danger] = "Something went weird, You didn't save anything"
      render :new
    end

  end

  private

  def whitelisted_params
    params.require(:category).permit(:name)
  end
end
