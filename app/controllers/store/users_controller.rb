class Store::UsersController < ApplicationController


  def require_current_user
    unless current_user == User.find(params[:id])
      flash[:error] = "Access denied!!!"
      redirect_to root_url
    end
  end

end
