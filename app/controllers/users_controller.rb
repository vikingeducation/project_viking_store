class UsersController < ApplicationController
  def index
    @users = User.all
    @users_data = {}

    @users.each do |user|
      @users_data[user.id.to_s] = {
        city: user.addresses.first.city.name,
        state: StatesHelper::STATE_POSTAL_CODES.key(user.addresses.first.state.name),
        num_placed_orders: user.num_placed_orders,
        last_order_date: user.last_order_date
      }
    end

    render layout: "admin_portal"
  end
end
