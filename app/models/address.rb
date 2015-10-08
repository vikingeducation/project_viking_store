class Address < ActiveRecord::Base
  belongs_to :city
  belongs_to :state
  belongs_to :user
  has_many :billing_orders, :class_name => 'Order', :foreign_key => :billing_id
  has_many :shipping_orders, :class_name => 'Order', :foreign_key => :shipping_id

  validates :street_address,
            :presence => true,
            :length => {
              :maximum => 64
            }

  validates :zip_code,
            :presence => true

  validates :city,
            :presence => true

  validates :state,
            :presence => true

  validates :user,
            :presence => true

  before_destroy :dissociate

  def dissociate
    if placed_orders.present?
      false
    else
      billing_orders.update_all(:billing_id => nil)
      shipping_orders.update_all(:shipping_id => nil)
      user.update(:billing_id => nil) if user.billing_id == id
      user.update(:shipping_id => nil) if user.shipping_id == id
    end
  end

  def orders
    orders_relation.to_a
  end

  def placed_orders
    placed_orders_relation.to_a
  end

  def carts
    carts_relation.to_a
  end

  def full_address
    "#{street_address} - #{city.name}, #{state.name}"
  end


  private
  def orders_relation
    billing_orders.merge(shipping_orders)
  end

  def placed_orders_relation
    orders_relation.where('checkout_date IS NOT NULL')
  end

  def carts_relation
    orders_relation.where('checkout_date IS NULL')
  end
end
