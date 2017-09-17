class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def show
    @category = Category.find(params[:id])
    @products = Product.where(:category_id => params[:id])
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(category_form_params)
      flash[:success] = "Category updated successfully."
      redirect_to categories_path
    else
      flash[:error] = "Category not updated"
      render :show
    end
  end

  def create
    @category = Category.new(category_form_params)
    if @category.save
      flash[:success] = "Category created successfully."
      redirect_to category_path(@category)
    else
      flash[:error] = "Category not created"
      render :index
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    @category = Category.find(params[:id])
    if @category.destroy
      flash[:success] = "Category deleted successfully."
      redirect_to categories_path
    else
      flash[:error] = "Category not deleted"
      redirect_to session.delete(:return_to)
    end
  end

private
  def category_form_params
    params.require(:category).permit(:name, :description)
  end
end
