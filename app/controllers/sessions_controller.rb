class SessionsController < ApplicationController

  before_action :store_referer, :only => [:new]


  def new
  end


  def create
    user = User.find_by_email(params[:email])
    if user
      sign_in user
      flash[:success] = "Thanks for signing in!"
      redirect_to referer
    else
      flash.now[:error] = "No record found.  Please sign up!"
      render :new
    end
  end


  def destroy
    if sign_out
      flash[:success] = "You have successfully signed out."
    else
      flash[:error] = "Oops."
    end

    session.delete(:referer) if session[:referer]
    redirect_to root_path
  end


  private


  def store_referer
    # used .request_uri instead of  .path  because it won't carry over ?category_id query param
    # this will get fixed if I nest Product under Category
    referer = URI(request.referer)
    session[:referer] = referer.request_uri unless referer.path == "/session/new"
  end


  def referer
    session.delete(:referer)
  end

end
