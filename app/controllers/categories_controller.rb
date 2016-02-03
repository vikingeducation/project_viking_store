class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.new( category_params )
    if @category.save
      redirect_to admin_path, notice: "Category Created"
    else
      flash.now[:alert] = "Failed to Create Category."
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
    if @category.update(category_params)
      redirect_to admin_path, notice: "Category Updated!"
    else
      flash.now[:alert] = "Failed to Edit Category."
      render :edit
    end
  end

  def destroy
    @category = Category.find( params[:id] )
    if @category.destroy
      redirect_to admin_path, notice: "Category Deleted!"
    else
      redirect_to :back, alert: "Failed to Delete Category."
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
