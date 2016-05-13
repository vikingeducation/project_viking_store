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
      flash.now[:danger] = "Something went wrong, You didn't save anything"
      render :new
    end
  end

  def show
    @category = Category.find(params[:id])
    @products_of_category = Product.by_category(@category.id)
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(whitelisted_params)
      flash[:success] = "You Succesfully Edit the Category"
      redirect_to categories_path
    else
      flash.now[:danger] = "Something whent wrong, You should double check"
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy

      # Reset Category id to nil for products which category is deleted
      Product.where(category_id: @category.id).update_all(category_id: nil)

      flash[:success] = "You Succesfully Delete the #{@category.name.titleize} Category"
      redirect_to categories_path
    else
      flash[:danger] = "Something went wrong, The Category wasn't delete"
      redirect_to(:back)
    end

  end

  private

  def whitelisted_params
    params.require(:category).permit(:name)
  end
end
