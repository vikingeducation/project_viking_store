class CreditCard < ApplicationRecord

  belongs_to :user

  def last_four
    card_number.chars.pop(4).join('')
  end

  def dropdown
    "#{nickname}: #{last_four}"
  end

end
