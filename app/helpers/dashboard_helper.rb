module DashboardHelper
	# For the order_by_date function we need to return
	# today, yesterday, or the actual date. This function
	# will take care of that.
	def what_is_the_date?(days_removed)
		if days_removed == 0 
			"Today"
		elsif days_removed == 1
			"Yesterday"
		else
			days_removed.days.ago.strftime("%B %e, %Y")
		end
	end
end
