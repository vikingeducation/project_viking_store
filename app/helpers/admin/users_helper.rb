module Admin::UsersHelper

  def user_state(users_id)
    State.select(:name).
          joins(:addresses).
          where("addresses.user_id" => users_id).
          first
  end

  def user_city(users_id)
    City.select(:name).
         joins(:addresses).
         where("addresses.user_id" => users_id).
         first
  end

  def user_orders(users_id)
    Order.where(user_id: users_id).
          group(:user_id).
          where.not(checkout_date: nil).
          count.
          values.
          first
  end

  def user_last_order(users_id)
    @order = Order.where(user_id: users_id).
                   group(:user_id, "orders.id").
                   where.not(checkout_date: nil).
                   order(checkout_date: :desc).
                   first
    @order.nil? ? "N/A" : @order[:checkout_date].strftime("%F")
  end

end
