class Admin::CategoriesController < ApplicationController

  layout "admin"

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "New category created"
      redirect_to admin_categories_path
    else
      flash.now[:danger] = "Failed to create category"
      render :new
    end
  end

  def show
    @category = Category.find(params[:id])
    @products = Product.where(:category_id => params[:id])
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(category_params)
      flash[:success] = "Category updated"
      redirect_to root_path
    else
      flash.now[:danger] = "Failed to update category"
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:success] = "Category deleted"
    redirect_to root_path
  end

  # -----------------------------------------------------------------
  # Helpers
  # -----------------------------------------------------------------

  def category_params
    params.require(:category).permit(:name, :description)
  end

end
