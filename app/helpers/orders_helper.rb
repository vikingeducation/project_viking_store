module OrdersHelper

  def display_status(order)
    order.placed? ? "PLACED" : raw("<span class='unplaced'>UNPLACED</span>")
  end

end
