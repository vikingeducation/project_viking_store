class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end


  def new
    @category = Category.new
  end

  def show
    @category = Category.find(params[:id])
    @products = Category.get_all_products(params[:id])
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      flash[:success] = "You've Sucessfully Updated the Category!"
      redirect_to category_path(@category)
    else
      flash.now[:error] = "Error! Category wasn't be updated!"
      render :edit
    end
  end

  def destory
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
