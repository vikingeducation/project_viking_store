module Admin::OrdersHelper
  def new_or_cart(user_id)
    user = User.find(user_id)
    if user.has_cart?
      edit_admin_order_path(user.cart.id)
    else
      new_admin_order_path(user_id: user_id)
    end
  end
end
