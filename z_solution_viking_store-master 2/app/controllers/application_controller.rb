class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :current_user
  helper_method :current_user
  helper_method :signed_in_user?

  private

  def sign_in(user)
    session[:current_user_id] = user.id
    current_user = user
  end

  def sign_out
    @current_user = nil
    session.delete(:current_user_id)
    session[:current_user_id].nil? && @current_user.nil?
  end

  def current_user
    if @current_user && session[:current_user_id] == @current_user.id
      @current_user
    elsif session[:current_user_id]
      @current_user = User.find_by_id(session[:current_user_id])
    end
  end

  def current_user=(user)
    @current_user = user
  end

  def signed_in_user?
    @current_user.present?
  end
end
