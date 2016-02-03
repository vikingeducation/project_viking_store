class AdminsController < ApplicationController
  def index
    @user_state = User.join_billing_state.to_a
    @user_city = User.join_billing_city.to_a
  end
end
