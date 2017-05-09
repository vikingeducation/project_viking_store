class Admin::AddressesController < ApplicationController

  layout 'admin_portal_layout'

  def index
    @addresses = Address.all
  end

  def show
    @address = Address.find(params[:id])
  end

  # def new
  #   @category = Category.new
  #   # render "/dashboard/new_categ", :locals => {:category => @category }
  # end

  # def create
  #   @category = Category.new(whitelisted_category_params)
  #   if @category.save
  #     flash[:success] = "New Category has been saved"
  #     redirect_to admin_categories_path
  #   else
  #     flash.now[:danger] = "New Category WAS NOT saved. Try again."
  #     render 'new', :locals => {:category => @category}
  #   end
  # end

  # def edit
  #   @category = Category.find(params[:id])
  #   # render 'dashboard/edit_categ', :locals => {:category => @category}
  # end

  # def update
  #   @category = Category.find(params[:id])
  #   if @category.update_attributes(whitelisted_category_params)
  #     flash.now[:success] = "Category has been updated"
  #     redirect_to admin_categories_path
  #   else
  #     flash[:danger] = "Category hasn't been saved."
  #     render 'edit', :locals => {:category => @category}
  #   end
  # end

  # def destroy
  #   @category = Category.find(params[:id])
  #   if @category.destroy
  #     flash[:success] = "Category deleted successfully!"
  #     redirect_to admin_categories_path
  #   else
  #     flash[:danger] = "Failed to delete category"
  #     redirect_to request.referer
  #   end
  # end

  # private
  # def whitelisted_category_params
  #   params.require(:category).permit(:name )
  # end


end
