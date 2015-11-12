class OrderContent < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  after_validation :combine_products
  after_update :remove_zero_quantity


  private


  def remove_zero_quantity
    destroy if quantity == 0  
  end


  def combine_products
    existing = OrderContent.where("order_id = ? AND product_id = ?", order_id, product_id)
    if !existing.empty?
      total_quantity = existing.pluck(:quantity).sum
      existing.destroy_all
      self.quantity += total_quantity
    end
  end

end
