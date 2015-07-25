class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def show
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(white_listed_cat_params)
    if @category.save
      flash[:success] = "New category created"
      redirect_to @category
    else
      flash.now[:error] = "Did not create category, try again."
      render :new
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(white_listed_cat_params)
      flash[:success] = "Category updated."
      redirect_to @category
    else
      flash.now[:error] = "Did not update category, try again."
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      flash[:success] = "Category deleted."
      redirect_to categories_path
    else
      flash.now[:error] = "Can not be deleted."
      render :edit
    end
  end
end
