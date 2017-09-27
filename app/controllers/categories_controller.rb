class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all.order(:name)

    render layout: "admin_portal"
  end

  def show
    @products_in_category = @category.products_in_category

    render layout: "admin_portal"
  end

  def new
    @category = Category.new

    render layout: "admin_portal"
  end

  def create
    @category = Category.new(whitelisted_category_params)

    if @category.save
      flash[:success] = "New Category successfully created."
      redirect_to categories_path
    else
      flash.now[:error] = "Error creating Category. See detailed messages below."
      render layout: "admin_portal", template: "categories/new"
    end
  end

  def edit
    render layout: "admin_portal"
  end

  def update
    if @category.update(whitelisted_category_params)
      flash[:success] = "Category successfully updated."
      redirect_to categories_path
    else
      flash.now[:error] = "Error updating Category. See detailed messages below."
      render layout: "admin_portal", template: "categories/edit"
    end
  end

  def destroy
    session[:return_to] ||= request.referer

    if @category.destroy
      flash[:success] = "Category successfully deleted."

      redirect_to categories_path
    else
      flash[:error] = "Error deleting Category."
      redirect_to session.delete(:return_to)
    end
  end

  private

  def find_category
    @category = Category.find(params[:id])
  end

  def whitelisted_category_params
    params.require(:category).permit(:name, :description)
  end
end
