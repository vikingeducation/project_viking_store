class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(session_params[:email])
    if @user
      sign_in(@user)
      TempOrder.merge(session, @user.cart)
      flash[:success] = 'You have been signed in successfully'
      redirect_to root_path
    else
      flash.now[:error] = 'Unable to sign in'
      render :new
    end
  end

  def destroy
    if sign_out
      flash[:success] = 'Signed out successfully'
    else
      flash[:error] = 'Unable to sign out'
    end
    redirect_to request.referer
  end


  protected
  def assert_id
    # empty override since has no ID
    # no need to validate it
  end

  def session_params
    params.permit(:email)
  end
end
