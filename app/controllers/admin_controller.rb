class AdminController < ApplicationController

  layout "admin_portal"

  def index

  end

  def categories
    @column_names = ["id","name","description","created_at","updated_at","show","edit","delete"]
    @categories = Category.all_in_arrays
  end

  def create_category
    @category = Category.new(whitelisted_params)
    if @category.save 
      redirect_to "/admin/categories"
      flash[:notice] = "New Category Created!"
    else
      flash[:alert] = "New Category Could Not Be Created, Please Try Again."
      render :new_category
    end
  end

  def new_category
    @category = Category.new
  end

  def show_category
    @category = Category.find(params[:id])
  end

  private

  def whitelisted_params
    params[:category] ? params.require(:category).permit(:name,:description) : params.permit(:name,:description)
  end

end
