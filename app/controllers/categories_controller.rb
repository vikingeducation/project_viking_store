class CategoriesController < ApplicationController

  layout "admin_portal"

  def create
    @category = Category.new(whitelisted_params)
    if @category.save 
      redirect_to :categories
      flash[:notice] = "New Category Created!"
    else
      flash.now[:alert] = "New Category Could Not Be Created, Please Try Again."
      render :new_category
    end
  end

  def destroy
    Category.find(params[:id]).destroy
    redirect_to categories_path
    flash[:notice] = "Category Deleted!"
  end

  def edit
    @category = Category.find(params[:id])
  end

  def index
    @column_headers = ["id","name","show","edit","delete"]
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def show
    @category = Category.find(params[:id])
    @column_names = ["id","name"]
  end

  def update
    @category = Category.find(params[:id])
    @category.update_attributes(whitelisted_params)
    if @category.save
      redirect_to :categories
      flash[:notice] = "Category Updated!"
    else
      flash.now[:alert] = "Category Couldn't be Updated, Try Again."
      render :edit
    end
  end

  private

  def whitelisted_params
    params[:category] ? params.require(:category).permit(:name,:description) : params.permit(:name,:description)
  end

end
