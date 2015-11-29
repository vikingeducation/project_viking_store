class AdminController < ApplicationController
  layout 'admin'

  def valid_user
    if params.has_key?(:user_id) && User.exists?(params[:user_id])
      User.find(params[:user_id])
    end
  end
end