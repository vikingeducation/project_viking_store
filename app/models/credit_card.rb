class CreditCard < ApplicationRecord
  # a CreditCard can only belong to a single User.
  belongs_to :user

  # a CreditCard can be used to pay for many Orders.
  # if a User and his CreditCards are destroyed, we want
  # to preserve Orders.
  has_many :orders, dependent: :nullify

  def to_s
    self.card_number.scan(/[0-9]{4}/).join(" ")
  end

  def last_4_digits
    len = self.to_s.length
    self.to_s[len - 5..len - 1]
  end
end
