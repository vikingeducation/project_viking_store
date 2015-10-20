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

  # 
  def placed_orders
    orders.where('checkout_date IS NOT NULL')
  end

  def last_four_digits
    card_number[-4..-1]
  end

  def name
    "(#{brand}) ending with ...#{last_four_digits}"
  end
end
