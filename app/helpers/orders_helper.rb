module OrdersHelper

  def display_status(order)
    order.placed? ? raw("<span class='placed'>PLACED</span>") : raw("<span class='unplaced'>UNPLACED</span>")
  end

  def user_order_index_buttons
    if params[:user_id]
      raw("#{ link_to 'New Order', new_admin_user_order_path(params[:user_id]), class: button_classes('success')}  #{link_to 'Back', admin_user_path(params[:user_id]), class: button_classes }")
    end
  end


end
