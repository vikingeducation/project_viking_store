class SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user
      sign_in user
      flash[:success] = "Thanks for signing in!"
      redirect_to root_path
    else
      flash.now[:error] = "Couldn't sign in!"
      render :new
    end
  end

  def destroy
    user = current_user
    if sign_out
      flash[:success] = "You have successfully signed out."
      redirect_to root_path
    else
      flash[:error] = "Something went wrong when signing you out."
      redirect_to root_path
    end
  end
end
