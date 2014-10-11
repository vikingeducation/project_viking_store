module UsersHelper

  def last_order_date(user)
    if user.orders.where(:checked_out => true).size > 0
      user.orders.where(:checked_out => true).order(:checkout_date).
                              last.checkout_date.strftime("%Y-%m-%d")
    else
      "N/A"
    end
  end

  def billing_city(user)
    user.billing_address ? user.billing_address.city.name : "N/A"
  end

  def billing_state(user)
    user.billing_address ? user.billing_address.state.name : "N/A"
  end

  private

end
