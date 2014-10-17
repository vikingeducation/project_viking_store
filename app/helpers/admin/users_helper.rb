module Admin::UsersHelper
  def cart_link(user)
    if user.orders.all?(&:checked_out)
    	"Unplaced Order"
    else
    	(link_to "Unplaced Order", admin_user_order_path(user.id, user.orders.where(checked_out: false).first.id))
    end
    # user.orders.all?(&:checked_out) ? "Unplaced Order" : (link_to "Unplaced Order", admin_user_order_path(user.id, user.orders.where(checked_out: false).first.id))
  end
end
