class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      sign_in user
      flash[:success] = "Signed in"
      redirect_to root_path
    else
      flash.now[:error] = "Failed to sign in"
      render :new
    end
  end

  def destroy
    if sign_out
      flash[:success] = "Signed out"
      redirect_to root_path
    else
      flash[:error] = "Failed to sign out"
      redirect_to root_path
    end
  end
end
