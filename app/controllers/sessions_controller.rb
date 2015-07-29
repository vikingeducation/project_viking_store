class SessionsController < ApplicationController

  def new
  end


  def create
    user = User.find_by_email(params[:email])
    if user
      sign_in user
      flash[:success] = "Thanks for signing in!"
    else
      flash.new[:error] = "We couldn't sign you in due to an error."
      render :new
    end
  end


  def destroy
    user = current_user
    if sign_out
      flash[:success] = "You have successfully signed out."
      redirect_to root_path
    else
      flash[:error] = "Oops."
      redirect_to root_path
    end
  end

end
