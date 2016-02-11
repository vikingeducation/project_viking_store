class SessionsController < ApplicationController


  def new
  end

  def create
    user = User.find_by_email(params["/sessions"][:email])
    if user
      sign_in_user(user)
      flash[:success] = "Signed In"
      redirect_to products_path
    else
      flash.now[:error] = "Failed to sign in"
      render :new
    end
  end



  def destroy
    if sign_out
      flash[:success] = "You have been signed out"

    else
      flash[:error] = "Failed to sing out"
    end
    redirect_to products_path
  end



end
