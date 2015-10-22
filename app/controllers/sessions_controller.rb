class SessionsController < ApplicationController
  def destroy
    reset_session
    flash[:success] = 'Session destroyed'
    redirect_to request.referer
  end


  protected
  def assert_id
  end
end
