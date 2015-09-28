class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :assert_id, :only => [:show, :edit, :update, :destroy]


  protected
  def assert_id
    redirect_to '/404.html' unless params[:controller].singularize.classify.constantize.exists?(params[:id])
  end
end
