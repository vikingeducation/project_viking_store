class User < ApplicationRecord
	def self.past_days(n)
		User.where(:created_at => (Time.now - n.days)..Time.now)
	end
end
