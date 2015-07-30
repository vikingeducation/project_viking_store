class OrderContentValidator < ActiveModel::Validator
  # Product id and quantity cannot be out of range.
  # Cannot create order_content rows if product or order does not exist.
  def validate(record)

    if record.product_id.to_i >= 10000 ||  record.product_id.to_i < 1
      record.errors[:product_id] << "The product id is out of range."
    end

    if record.quantity.to_i >= 10000 || record.quantity.to_i < 1
      record.errors[:quantity] << "The quantity is out of range."
    end

    unless Product.find_by(id: record.product_id)
      record.errors[:product_id] << "The specified product ID does not exist."
    end

    unless Order.find_by(id: record.order_id)
      record.errors[:order_id] << "The specified order ID does not exist."
    end
  end
end

