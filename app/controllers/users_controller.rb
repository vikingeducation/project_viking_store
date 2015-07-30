class UsersController < ApplicationController

  #before_action :require_login, :exclude => [:new, :create]

  def new
    @user = User.new
    @address_one = @user.created_addresses.build
  end


  def create

  end

end
