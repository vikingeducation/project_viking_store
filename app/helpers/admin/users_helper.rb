module Admin::UsersHelper
  def link_to_view_cart(user)
    o = user.orders.where('checkout_date IS NULL')
    if o.empty?
      'View Unplaced Order (Cart)'
    else
      link_to 'View Unplaced Order (Cart)', admin_user_order_path(user, o.first)
    end
  end

end
