class AdminController < ApplicationController
  layout 'admin'

  def index
  end

  protected
  def assert_id
    model = params[:controller].singularize
      .classify
      .gsub('Admin::', '')
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






