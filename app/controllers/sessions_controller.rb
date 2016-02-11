class SessionsController < ApplicationController
  # renders sign-in form
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      sign_in user
      flash[:success] = "Thanks for signing in!"
      redirect_to root_path
    else
      flash.now[:error] = "We couldn't sign you in due to errors."
      render :new
    end
  end

  def destroy
    if sign_out
      flash[:success] = "You have successfully signed out!"
      redirect_to root_path
    else
      flash[:error] = "You can't sign out! You're stuck here forever! Bwahaha!"
      redirect_to root_path
    end
  end
end
