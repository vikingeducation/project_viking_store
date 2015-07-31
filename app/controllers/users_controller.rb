class UsersController < ApplicationController

  # Don't verify that we're signed in for actions required to 
  # create a new user!  Otherwise, use the method that already
  # exists in our ApplicationHelper module to verify signed-in status.
  before_action :require_login, :exclude => [:new, :create]

  def new
  end

  def create
  end

  # For certain sensitive actions, we only want to allow the
  # user to attempt them if they are the user that action is 
  # meant to address.  For instance, updating a profile should
  # only be allowable for the current user.
  before_action :require_current_user, :only => [:edit, :update, :destroy]

  def edit
  end

  # Now you can assume that current_user exists since the
  # before_action catches all other cases
  # Run our update directly on the current user!
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
