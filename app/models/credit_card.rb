class CreditCard < ActiveRecord::Base
  belongs_to :user

  has_many :billed_orders, :class_name => 'Order', 
                           :foreign_key => :billing_card_id,
                           :dependent => :nullify

  validates :card_number, :exp_month, :exp_year, :user_id, :presence => true
  validates :card_number, :uniqueness => true
  validates :exp_month, :numericality => { :only_integer => true, :greater_than => 0, :less_than_or_equal_to => 12 }
  validates :exp_year, :numericality => { :only_integer => true, :greater_than_or_equal_to => Time.now.year }

  def id_and_card_number 

    "#{id}. Ending in #{card_number}"

  end
  
end
