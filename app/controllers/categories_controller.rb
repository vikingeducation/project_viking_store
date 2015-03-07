class CategoriesController < ApplicationController

  def index
    @categories = Category.all
    render layout: "admin"
  end

  def new
    @category = Category.new
    render layout: "admin"
  end

  def create
    @category = Category.new whitelisted_category_params
    if @category.save
      flash[:success] = "You created a new category."
      redirect_to categories_path
    else
      flash[:error] = "There was an error."
      render :new
    end
  end

  def show
    @category = Category.find params[:id]
    render layout: "admin"
  end

  def edit
    @category = Category.find params[:id]
    render layout: "admin"
  end

  def update
    @category = Category.find params[:id]
    if @category.update whitelisted_category_params
      flash[:success] = "You successfully updated the category."
      redirect_to categories_path
    else
      flash[:error] = "There's an error."
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    session[:return_to] ||= request.referer
    if @category.destroy!
      flash[:success] = "That category was deleted."
      redirect_to categories_path
    else
      flash[:error] = "It didn't work."
      redirect_to session.delete(:return_to)
    end
  end

  private

  def whitelisted_category_params
    params.require(:category).permit(:name,:description)
  end
end
