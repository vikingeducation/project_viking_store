class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])

    if user
      sign_in user
      flash[:success] = "Thanks for signing in!"
      redirect_to root_path
    else
      flash.now[:error] = "We couldn't sign you in because REASONS."
      render :new
    end
  end

  def destroy
    user = current_user

    if sign_out(user)
      flash[:success] = "You have successfully signed out"
      redirect_to root_path
    else
      flash[:error] = "Angry robots have prevented you from signing out.  You're stuck here forever."
      redirect_to root_path
    end
  end
end
