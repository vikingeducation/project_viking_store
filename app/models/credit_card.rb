class CreditCard < ApplicationRecord
  belongs_to :user

  validates :user_id, :card_number, :exp_month, :exp_year, :brand,
            :presence => true
  validates :card_number,
            :format => {:with => /d+/},
            :length => {:is => 16}
end
