class CreditCard < ApplicationRecord
  validates :card_number,
            presence: true,
            uniqueness: true,
            length: { is: 16 },
            numericality: { only_integer: true }


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

  def last_4_digits_text
    "Ending in #{self.last_4_digits}"
  end
end
