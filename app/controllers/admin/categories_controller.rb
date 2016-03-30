class Admin::CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(whitelisted_params)
    if @category.save
      flash[:success] = "Category created successfully."
      redirect_to admin_categories_path
    else
      flash.now[:error] = "Failed to create category."
      render 'new'
    end
  end

  def show
    @category = Category.find(params[:id])
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(whitelisted_params)
      flash[:success] = "Category updated successfully."
      redirect_to admin_categories_path
    else
      flash.now[:error] = "Failed to update category."
      render 'edit'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      flash[:success] = "Category destroyed successfully."
      redirect_to admin_categories_path
    else
      flash.now[:error] = "Failed to destroye category."
      render 'index'
    end
  end

  private

  def whitelisted_params
    params.require(:category).permit(:name)
  end
end