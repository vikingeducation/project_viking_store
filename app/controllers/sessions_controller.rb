class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      sign_in user
      flash[:success] = "Signed in"
      redirect_to root_path
    else
      flash.now[:error] = "Failed to sign in"
      render :new
    end
  end

  def destroy
    user = current_user
    if sign_out(user)
      flash[:success] = "Signed out"
      redirect_to root_path
    else
      flash[:error] = "Failed to sign out"
      redirect_to root_path
    end
  end

  private

  def sign_in(user)
    session[:current_user_id] = user.id
    current_user = user
  end

  def sign_out
    session.delete(:current_user_id) && current_user = nil
  end

  def current_user
    return nil unless session[:current_user_id]
    @current_user ||= User.find(params[:current_user_id])
  end

  def current_user=(user)
    @current_user = user
  end

  def signed_in_user?
    @current_user.present?
  end
end
