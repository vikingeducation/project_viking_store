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
end
