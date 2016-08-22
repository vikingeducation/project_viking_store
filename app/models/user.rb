class User < ApplicationRecord


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
