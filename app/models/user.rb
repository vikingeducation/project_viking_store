class User < ApplicationRecord
  has_many :addresses
  has_many :orders
  has_many :credit_cards, :dependent => :destroy

  has_many :products,
           :through => :orders

  belongs_to :default_billing_address,
             :foreign_key => :billing_id,
             class_name: "Address"

  belongs_to :default_shipping_address,
             :foreign_key => :shipping_id,
             class_name: "Address"


  def self.new_signups_7
    User.where("created_at > '#{Time.now.to_date - 7}'").count
  end

  def self.new_signups_30
    User.where("created_at > '#{Time.now.to_date - 30}'").count
  end

  def self.total_signups
    User.count
  end





end
