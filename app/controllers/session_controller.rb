class SessionController < ApplicationController

  def new
  end


  def create
    user = User.find_by_email(params[:session][:email])
    if user
      sign_in user
      flash[:success] = "Welcome back, #{user.first_name}!"
      redirect_to root_path
    else
      flash.now[:danger] = "Sorry, we couldn't sign you in!"
      render :new
    end
  end


  def destroy
    if sign_out
      flash[:info] = "You have signed out"
      redirect_to root_path
    else
      flash[:error] = "You can't leave, she won't let you."
      redirect_to root_path
    end
  end


  private


  def session_params
    params.require(:session).permit(:email, :password)
  end

end
