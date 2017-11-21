class CategoryValidator < ActiveModel::Validator
  def validate(record)
    error_message = error_message(record.category_id)
    record.errors[:category] << error_message if error_message
  end

  private

  def error_message(category_id)
    category_not_filled_error(category_id) || category_does_not_exists_error(category_id)
  end

  def category_does_not_exists_error(category_id)
    "does not exists!" unless Category.exists?(category_id)
  end

  def category_not_filled_error(category_id)
    "can't be blank" if category_id.blank?
  end
end
