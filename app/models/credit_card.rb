class CreditCard < ApplicationRecord
  belongs_to :user, :optional => true
  has_many :orders

  def last_4_digits
    "Ending in #{self.card_number[-4..-1]}"
  end
end
