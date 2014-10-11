class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end
  def edit
  end

  def new 
    @category = Category.new
  end

  def show
    @category = Category.find(params[:id])
  end

  def destroy
  end

  def create
  @category = Category.new(cat_params)
    if @category.save
      flash[:success] = "Category created!"
      redirect_to categories_path
    else
      flash[:error] = "Whoops!"
      render 'new' 
    end
  end

  private
  def cat_params
    params.require(:category).permit(:name, :description)
  end

end
