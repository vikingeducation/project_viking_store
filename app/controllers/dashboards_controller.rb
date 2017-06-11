class DashboardsController < ApplicationController
  def show
   @users = User.all
   render :layout
  end

 def new
   @user = User.new
 end

 def create
   @user = User.new(user_params)
   if @user.save
     flash[:success] = "Welcome to the Sample App!"
     redirect_to @user
   else
     render 'new'
   end
 end

 def edit
   @user = User.find(params[:id])
 end

 def update
   @user = User.find(params[:id])
   if @user.update_attributes(user_params)
     flash[:success] = "Update successful!"
   else
     render 'edit'
   end
 end

 def destroy
  @user = User.find(params[:id])
  if @user.delete
   flash[:success] = "User deleted!"
  else
    render 'index'
  end
 end
end
