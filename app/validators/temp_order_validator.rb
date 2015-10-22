class TempOrderValidator < ActiveModel::Validator
  def validate(record)
    items_present(record)
    numeric_quantity(record)
    present_product(record)
  end


  private
  def items_present(record)
    record.errors.add(:base, 'items must not be empty') unless record.items.present?
  end

  def numeric_quantity(record)
    unless record.items.all? {|item| item[:quantity].to_s =~ /\A\d+\Z/}
      record.errors.add(:quantity, 'must be a positive whole number')
    end
  end

  def present_product(record)
    unless record.items.all? {|item| Product.exists?(item[:product_id])}
      record.errors.add(:product, 'must exist')
    end
  end
end
