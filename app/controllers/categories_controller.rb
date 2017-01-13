class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @products = Product.category(params[:id])
  end

  def index
    @categories = Category.all
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Success!"
      redirect_to categories_path
    else
      flash.now[:warning] = @category.errors.full_messages
      render :new
    end
  end

  def new
    @category = Category.new
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      flash[:success] = "Success!"
      redirect_to categories_path
    else
      flash[:warning] = @category.errors.full_messages
      redirect_to(:back)
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      flash[:success] = "Success!"
      redirect_to categories_path
    else
      flash.now[:warning] = @category.errors.full_messages
      render :edit
    end
  end

  private

    def category_params
      params.require(:category).permit(:name)
    end
end
