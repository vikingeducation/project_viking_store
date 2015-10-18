class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :assert_id, :only => [:show, :edit, :update, :destroy]


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
