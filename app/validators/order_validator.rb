class OrderValidator < ActiveModel::Validator
  # Validates that the user doesn't already have a shopping cart
  # If they do, they can't create new orders and can't set existing orders
  # to unplaced.
  def validate(record)
    if record.checkout_date.nil? && record.has_cart?
      record.errors[:checkout_date] << "You cannot have more than one unplaced order."
    end
  end
end
