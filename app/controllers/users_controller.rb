class UsersController < ApplicationController
  def new
    @user = User.new
    2.times do
      @user.addresses.build
    end
  end
end
