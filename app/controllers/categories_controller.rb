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
      flash.notice = "You created Category"
      redirect_to categories_path
    else
      render :new
    end
  end

  def show
    @category = Category.find(params[:id])
    @category_products = Category.find_products(@category).limit(3)
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(whitelisted_params)
      flash.notice = "You updated Category"
      redirect_to categories_path
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      flash.notice = "You deleted Category"
      redirect_to categories_path
    end
  end

  private

    def whitelisted_params
      params.require(:category).permit(:name)
    end

end
