class User < ActiveRecord::Base

  def self.in_last(days = nil)
    if days.nil?
      self.count
    else
      self.where('created_at > ?', DateTime.now - days).count
    end
  end

  def self.top_states(limit = 3)
    self.joins('JOIN address ON users.billing_id = address.id').count('')
  end

end
