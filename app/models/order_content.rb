class OrderContent < ActiveRecord::Base
  
  belongs_to :order
  belongs_to :product

  before_create :combine_products
  after_save :remove_zero_quantity

  validate :product_exists


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


  def product_exists
    errors.add(:product_id, "is invalid") unless Product.exists?(self.product_id)
  end

end
