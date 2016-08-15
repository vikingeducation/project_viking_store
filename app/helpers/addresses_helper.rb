module AddressesHelper
  def addresses_orders(addy)
    addy.user.orders.where("orders.shipping_id = ?", addy.id)
  end
end
