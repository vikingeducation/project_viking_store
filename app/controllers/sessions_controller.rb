class SessionsController < ApplicationController

  def new
  end


  def create
    user = User.find_by_email(params[:email])
    if user
      sign_in user
      merge_visitor_cart
      flash[:success] = "Thanks for signing in!"
      redirect_to root_path
    else
      flash.now[:error] = "No record found.  Please sign up!"
      render :new
    end
  end


  def destroy
    if sign_out
      flash[:success] = "You have successfully signed out."
      redirect_to root_path
    else
      flash[:error] = "Oops."
      redirect_to root_path
    end
  end

end
