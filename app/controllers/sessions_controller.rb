class SessionsController < ApplicationController

  layout 'clear'

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user
      sign_in(user)
      flash[:success] = "Thanks for signing in!"
      redirect_to root_path
    else
      flash.now[:error] = "We didn't find a user associated with this email."
      render :new
    end
  end

  def destroy
    if sign_out
      flash[:success] = "You have successfully signed out"
      redirect_to root_path
    else
      flash[:error] = "Angry robots have prevented you from signing out.  You're stuck here forever."
      redirect_to root_path
    end
  end

end
