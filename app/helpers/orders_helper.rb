module OrdersHelper

    def order_create(user)

    if user
      link_to "Create a #{user.first_name} #{user.last_name} Address", new_admin_order_path(:user_id => user.id), class: 'btn btn-success btn-lg btn block'
    else
      render 'admin/shared/point_to_users_index'
    end

  end

  def show_order_title(order)

    if @order.checkout_date
      "Order #{@order.id}"
    else
      "Order #{@order.id} (Shopping Cart)"
    end

  end

end
