class SessionsController < ApplicationController

  def new

  end

  def create

    user = User.find_by_email(params[:email])
    if user
      sign_in user
      flash[:success] = "You have been signed in!"
    else
      flash.new[:error] = "You have failed to sign in - please try again."
    end

  end

  def destroy

    user = current_user
    if sign_out
      flash[:success] = "You have signed out!"
      redirect_to root_path
    else
      flash[:error] = "You have failed to sign out - please try again."
      redirect_to root_path
    end

  end

end
