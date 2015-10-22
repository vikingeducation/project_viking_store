class SessionsController < ApplicationController

  def new

  end

  def create

    user = User.find_by_email(params[:email])
    if user
      sign_in user
      merge_visitor_cart
      flash[:success] = "You have been signed in!"
      redirect_to root_path
    else
      flash.now[:error] = "You have failed to sign in - please try again."
      render :new
    end

  end

  def destroy

    if sign_out
      flash[:success] = "You have signed out!"
      redirect_to root_path
    else
      flash[:error] = "You have failed to sign out - please try again."
      redirect_to root_path
    end

  end

end
