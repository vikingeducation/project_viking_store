class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      sign_in user
      flash[:success] = "You've successfully logged in, #{user.first_name}!"
      user.merge_carts(session[:cart])
      session[:cart] = []
      redirect_to root_path
    else
      flash.now[:danger] = "There was an error and you could not be signed in."
      render :new
    end
  end

  def destroy
    user = current_user
    if sign_out
      flash[:success] = "You've successfully signed out!"
      redirect_to root_path
    else
      flash[:danger] = "You could not be signed out. Please try again."
      redirect_to root_path
    end
  end
end
