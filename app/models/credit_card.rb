class CreditCard < ActiveRecord::Base
  belongs_to :user

  has_many :billed_orders, :class_name => 'Order', :foreign_key => :billing_card_id, :dependent => :nullify


  def id_and_card_number
    "#{id}. Ending in #{card_number}"
  end


end
