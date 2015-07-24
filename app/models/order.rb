class Order < ActiveRecord::Base

def self.new_orders(input_day)
	self.where("created_at > ?", input_day.days.ago).count
end


end
