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


  def display_address(address_id)
    address = Address.find(address_id)
    city = City.find(address.city_id)
    state = State.find(address.state_id)
    address.street_address + ", " + city.name + ", " + state.name
  end


  def user_cc_info(user_id)
    @cc = CreditCard.find(user_id)
  end


  def order_value(order)
    sum = 0
    order.order_contents.each do |f|
      sum += (Product.find(f.product_id).price * f.quantity)
    end
    sum.to_s
  end



end
