class CategoriesController < ApplicationController
  layout 'admin'
  before_action :set_category, :except => [:index]

  def index
    @categories = Category.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @category.update(category_params)
      flash[:success] = 'Category created'
      redirect_to categories_path(@category)
    else
      flash.now[:error] = 'Category not created'
      render :new
    end
  end

  def update
    if @category.update(category_params)
      flash[:success] = 'Category updated'
      redirect_to categories_path(@category)
    else
      flash.now[:error] = 'Category not updated'
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = 'Category deleted'
    else
      flash[:error] = 'Category not deleted'
    end
    redirect_to categories_path
  end


  private
  def set_category
    @category = Category.exists?(params[:id]) ? Category.find(params[:id]) : Category.new
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
