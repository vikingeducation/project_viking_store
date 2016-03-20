class AdminController < ApplicationController

  layout "admin_portal"

  def index

  end

  def categories
    @column_names = ["id","name","description","created_at","updated_at","show","edit","delete"]
    @categories = Category.all
  end

  def create_category
    @category = Category.new(whitelisted_params)
    if @category.save 
      redirect_to "/admin/categories"
    else 
      render :new_category
    end
  end

  def new_category
    @category = Category.new
  end

  private

  def whitelisted_params
    params[:category] ? params.require(:category).permit(:name,:description) : params.permit(:name,:description)
  end

end
