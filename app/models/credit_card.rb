class CreditCard < ActiveRecord::Base
  # YOu wouldn't delete a user because you're deleting their creidt card, and considering the user_id is on this side, you don't have to do anything.
  belongs_to :user

  has_many :orders, :dependent => :nullify

  validates :exp_month,
            :exp_year,
            :ccv,
            :presence => true

  validates :card_number, length: { in: 1..50 }


  def last_four_digits
    "... #{self.card_number[-4..-1]}"
  end

end
