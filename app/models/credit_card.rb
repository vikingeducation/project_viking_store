class CreditCard < ActiveRecord::Base
  belongs_to :user
  has_many :orders

  def last_4
    self.card_number[-4..-1]
  end

end
