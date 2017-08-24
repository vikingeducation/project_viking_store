class CategoriesController < ApplicationController
  def index
    @categories = Category.all

    render layout: "admin_portal"
  end

  def show
    @category = Category.find(params[:id])
    @products_in_category = Category.products_in_category(@category.id)

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

  private

  def whitelisted_category_params
    params.require(:category).permit(:name, :description)
  end
end
