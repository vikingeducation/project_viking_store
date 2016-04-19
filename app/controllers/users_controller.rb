class UsersController < ApplicationController

  layout 'front_facing'

  def new
    @user = User.new
  end

end
