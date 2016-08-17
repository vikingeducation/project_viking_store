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
    @products = @category.products
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(whitelisted_params)
      flash[:success] = "Category successfully updated"
      redirect_to categories_path
    else
      flash[:error] = "Something went wrong updating your category"
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])

    if @category.destroy
      flash[:success] = "Category was successfully destroyed"
      redirect_to categories_path 
    else
      flash[:error] = "Could not delete Category"
      redirect_to :back
    end
  end

  def whitelisted_params
    params.require(:category).permit(:name, :description)
  end
end
