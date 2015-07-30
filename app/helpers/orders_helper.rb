module OrdersHelper
  def order_owner
    if @user
      content_tag(:h3, "#{@user.name}'s Orders")
    else
      content_tag(:h3,  "Orders")
    end
  end

  def button_for_new_order
    if @user
      link_to "Create a new order for #{@user.name}!",
              new_order_path(user_id: @user.id),
              class: "btn btn-primary"
    end
  end

  def display_date_or_na(order)
    if order.created_at.nil?
      "N/A"
    else
      order.created_at
    end
  end
end
