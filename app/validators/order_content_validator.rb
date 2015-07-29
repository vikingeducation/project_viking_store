class OrderContentValidator < ActiveModel::Validator
  def validate(record)
    binding.pry
    if record.product_id.to_i >= 2147483647
      record.errors[:product_id] << "The product id is way too large."
    end

    unless Product.find_by(id: record.product_id)
      record.errors[:product_id] << "The specified product ID does not exist."
    end

    unless Order.find_by(id: record.order_id)
      record.errors[:order_id] << "The specified order ID does not exist."
    end
  end
end

