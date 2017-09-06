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

  # returns the last 4 digits of the CreditCard
  def last_4_digits
    len = self.to_s.length
    self.to_s[len - 5..len - 1]
  end

  # returns a formatted string to be used in the Orders new page
  def last_4_digits_text
    "Ending in #{self.last_4_digits}"
  end

  # returns a formatted String representation of the CreditCard expiration date
  def expiration_date
    exp_month = self.exp_month.to_s
    exp_month = "0" + exp_month if exp_month.length == 1

    "#{exp_month}-#{self.exp_year}"
  end

  # returns the CreditCard holder's first name
  def holder_first_name
    self.user.first_name
  end

  # returns the CreditCard holder's last name
  def holder_last_name
    self.user.last_name
  end
end
