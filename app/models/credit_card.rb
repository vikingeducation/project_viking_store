class CreditCard < ActiveRecord::Base
  belongs_to :user

  validates :card_number, presence: true, format: { with: /[0-9]{16}/, message: "Card number must be 16 digits long."}
  validates :exp_month, presence: true, inclusion: { in: 1..12, message: "must be between an integer between 01 and 12." }
  validates :exp_year, presence: true, format: { with: /[0-9]{4}/, message: "Year must be a 4 digit number." }

  def last_four
    "Ending in #{card_number[-4..-1]}"
  end
end
