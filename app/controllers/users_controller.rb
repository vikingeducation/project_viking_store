class UsersController < ApplicationController
   def index
    @users = User.all
  end

  def new
    @user = Category.new
  end

  def create
    @user = Category.new(user_params)
    if @user.save
      flash[:success] = "You've Sucessfully Created a Category!"
      redirect_to category_path(@category)
    else
      flash.now[:error] = "Error! Category wasn't created!"
      render :new
    end
  end

  def show
    @category = Category.find(params[:id])
    @products = Category.get_all_products(params[:id])
  end

end
