class OrderContent < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates :quantity,
            :presence => true,
            :numericality => {:greater_than => 0}

  validates :order,
            :presence => true

  validates :product,
            :uniqueness => {:scope => [:order_id]},
            :presence => true

  # Returns the revenue for this order
  def revenue
    (quantity * product.price).to_f
  end

  # Returns an array of attribute hashes
  # ready for create or update
  def self.params_to_attributes(parameters)
    attrs = {}
    parameters[:order_content].each do |key, value|
      if attrs[value['product_id']]
        attrs[value['product_id']][:quantity] += value['quantity'].to_i
      else
        attrs[value['product_id']] = {
          :id => value['id'],
          :quantity => value['quantity'].to_i,
          :product_id => value['product_id'],
          :order_id => parameters['order_id']
        }
      end
    end
    attrs.map {|key, value| value}
  end
end
