class UsersController < ApplicationController
  
  layout 'admin_portal'

  def index
    @column_names = ["ID","Name","Joined","City","State","Orders","Last Order Date", "SHOW", "EDIT", "DELETE"]
    @users = User.all_in_arrays
  end

  def show
    @user = User.find(params[:id])
    # @category_name = Product.category_name(@product.category_id)
    # @times_ordered = Product.times_ordered(params[:id])
    # @number_of_carts_in = Product.number_of_carts_in(params[:id]).first.total
  end
end