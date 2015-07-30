class UsersController < ApplicationController

  def new
    @user = User.new
    @address_one = @user.created_addresses.build
  end


  def create

  end

end
