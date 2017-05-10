class Admin::AddressesController < ApplicationController

  layout 'admin_portal_layout'

  def index
    if params[:user_id]
      @addresses = Address.where(:user_id => params[:user_id])
    else
      @addresses = Address.all
    end
  end

  def show
    @address = Address.find(params[:id])
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(whitelisted_category_params)
    if @address.save
      flash[:success] = "New Address has been saved"
      redirect_to admin_addresses_path
    else
      flash.now[:danger] = "New Address WAS NOT saved. Try again."
      render 'new', :locals => {:address => @address}
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

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
