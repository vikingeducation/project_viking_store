class CategoriesController < ApplicationController
  layout "admin"

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new( whitelisted_params )
    if @category.save
      redirect_to categories_path, notice: "Category Created"
    else
      flash.now[:alert] = "Failed to Create Category."
      render :new
    end
  end

  def show
    @category = Category.find( params[:id] )
    @products =  @category.products
  end

  def edit
    @category = Category.find( params[:id] )
  end

  def delete
    @category = Category.find( params[:id] )
  end

  def whitelisted_params
    params.require(:category).permit(:name)
  end

end
