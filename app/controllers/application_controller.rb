class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :assert_id, :only => [:show, :edit, :update, :destroy]

  def sign_in(user)
    session[:current_user_id] = user.id
  end

  def sign_out
    reset_session
    @current_user = nil
    session[:current_user_id].nil? && @current_user.nil?
  end

  def current_user
    @current_user ||= User.find(session[:current_user_id]) if session[:current_user_id]
  end
  helper_method :current_user

  def signed_in_user?
    !!@current_user
  end
  helper_method :signed_in_user?


  protected
  def assert_id
    model = params[:controller].singularize
      .classify
      .constantize
    unless model.exists?(params[:id])
      flash[:error] = "#{params[:controller].singularize.titleize} not found"
      redirect_to url_for(
        :controller => params[:controller],
        :action => 'index'
      )
    end
  end
end
