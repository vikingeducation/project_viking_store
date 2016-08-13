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
      flash[:success] = "You have successfully created a Category"
      redirect_to categories_path
    else
      flash[:error] = "Something went wrong"
      render :new
    end
  end

  def show
    @category = Category.find(params[:id])
  end

  def whitelisted_params
    params.require(:category).permit(:name, :description)
  end
end
