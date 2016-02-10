class Address < ActiveRecord::Base

  belongs_to :user

  has_many :order_contents, :through => :user
  has_many :orders, :through => :order_contents, source: :order
  belongs_to :city
  belongs_to :state

  validates :street_address, length: { in: 1..64 }

  accepts_nested_attributes_for :city,
                                :reject_if => :all_blank


end
