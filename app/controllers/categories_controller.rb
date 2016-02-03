class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.new( category_params )
    if @category.save
      redirect_to admin_path, notice: "Category Created"
    else
      flash.now[:alert] = "Failed to Create Category"
      render :new
    end
  end

  def show
    @category = Category.find( params[:id] )
  end

  def edit
    @category = Category.find( params[:id] )
  end

  def update
    @category = Category.find( params[:id] )
  end

  def destroy
    @category = Category.find( params[:id] )
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
