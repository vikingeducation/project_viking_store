class OrderValidator < ActiveModel::Validator
  def validate(record)
    if record.checkout_date.nil? && record.has_cart?
      record.errors[:checkout_date] << "You cannot have more than one unplaced order."
    end
  end
end
