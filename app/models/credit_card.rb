class CreditCard < ActiveRecord::Base
  belongs_to :user

  has_many :orders

  def ending_in
    "Ending in #{card_number[-4..-1]}"
  end
end
