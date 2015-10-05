class CreditCard < ActiveRecord::Base
  belongs_to :user
  has_many :orders

  before_destroy :dissociate

  def dissociate
    if placed_orders.present?
      false
    else
      orders.update_all(:credit_card_id => nil)
    end
  end

  def placed_orders
    placed_orders_relation.to_a
  end


  private
  def placed_orders_relation
    orders.where('checkout_date IS NOT NULL')
  end
end
