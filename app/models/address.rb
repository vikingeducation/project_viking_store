class Address < ActiveRecord::Base
  belongs_to :state
  belongs_to :city
  belongs_to :user, :source => :billing_id
  belongs_to :user, :source => :shipping_id
  has_many :orders, :source => :billing_id
  has_many :orders, :source => :shipping_id
end
