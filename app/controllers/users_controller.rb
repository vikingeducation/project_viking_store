class UsersController < ApplicationController
  layout "admin"
  def index
    @users = User.all
    # @user_state = User.join_billing_state
    # @user_city = User.join_billing_city
  end
end

