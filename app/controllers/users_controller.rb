class UsersController < ApplicationController

  layout 'clear'
  
  before_action :require_login, :except => [:new, :create]

  def new
    @user = User.new
    @user.addresses.build
  end

  def create

  end

  before_action :require_current_user, :only => [:edit, :update, :destroy]

  def edit
  end

  def update
    if current_user.update(whitelisted_user_params)
      flash[:success] = "Successfully updated your profile"
      redirect_to root_url
    else
      flash.now[:failure] = "Failed to update your profile"
      render :edit
    end
  end

  def destroy
  end

  private
  # Note that you'd have to whitelist the params if they
  # are nested inside the `:user` key.
  # Here, we're making sure the current user is the same
  # as the user whose profile we're trying to edit/delete etc.
  def require_current_user
    unless current_user == User.find(params[:id])
      flash[:error] = "Access denied!!!"
      redirect_to root_url
    end
  end

end
