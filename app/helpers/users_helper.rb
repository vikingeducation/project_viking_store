module UsersHelper
  def cart_link(user)
    user.orders.all? { |o| o.checked_out} ? "Unplaced Order" : (link_to "Unplaced Order", admin_user_order_path(user.id, user.orders.where(checked_out: false).first.id))
  end
end
