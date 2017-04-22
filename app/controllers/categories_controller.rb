class CategoriesController < ApplicationController
  layout 'admin_portal_layout'

  def index_categ
    flash[:success] = "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Porro, alias."
    @all_categories = Category.all
    render "/dashboard/index_categ", :locals => {:all_categories => @all_categories }
  end

  def new_categ
    @category = Category.new
    render "/dashboard/new_categ", :locals => {:category => @category }
  end

  def create_categ
    @category = Category.new(whitelisted_category_params)
    if @category.save
      flash.now[:success] = "New Category has been saved"
      redirect_to "/admin_portal"
    else
      flash[:danger] = "New Category WAS NOT saved. Try again."
      render '/dashboard/new_categ', :locals => {:category => @category}
    end
  end

  def show_categ

  end

  def edit_categ
    @category = Category.find(params[:id])
  end

  def delete_categ

  end
end


private
def whitelisted_category_params
  params.require(:category).permit(:name)
end
