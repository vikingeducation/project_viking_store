class SessionsController < ApplicationController
  layout "shop"

  def new
    session[:return_to] = request.referer
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      signin( user )
      session[:cart] ||= {}
      update_db_cart
      update_tmp_cart
      flash[:success] = "Welcome #{user.full_name}"
      redirect_to session.delete(:return_to)
    else
      flash.now[:danger] = "Something went wrong"
      render :new
    end
  end

  def destroy
    update_db_cart
    if signout
      session[:cart] = {}
      flash[:success] = "You signed out"
      redirect_to products_path
    else
      flash.now[:danger] = "You cannot sign out, sorry"
      redirect_to(:back)
    end
  end

end
