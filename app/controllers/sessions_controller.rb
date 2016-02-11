class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      sign_in user
      flash.notice = "You have successfully signed in"
      redirect_to products_path
    else
      flash.now.notice = "Sorry it failed"
      render :new
    end
  end


  def destroy
    if sign_out
      flash.notice = "You successfully signed out"
      redirect_to products_path
    else
      flash.now.notice = "Sorry you couldn't log out"
      redirect_to products_path
    end
  end
end
