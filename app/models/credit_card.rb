class CreditCard < ActiveRecord::Base
  belongs_to :user
  has_many :orders

  validate :valid_card_number


  def display_card_number
    "Ending in #{card_number[-4..-1]}"
  end


  private


  def valid_card_number
    unless (Math.log10(card_number.to_i).to_i + 1) == 16
      errors.add(:card_number, "is invalid")
    end
  end
end
