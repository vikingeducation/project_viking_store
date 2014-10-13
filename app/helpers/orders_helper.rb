module OrdersHelper
  def index_order_create(user)
    if user
      (link_to "Create Order for #{user.name}", new_user_order_path(user), :class => "btn btn-block btn-default btn-lg btn-primary")
    else
      raw("<em>Create new orders from within #{(link_to 'User', users_path)} profiles </em>")
    end
  end

  def order_status(order)
    order.checked_out ? "PLACED" : "UNPLACED"
  end

  def order_title(order)
    order.checked_out ? "Order #{order.id}" : "#{order.user.name}'s Cart"
  end
end
