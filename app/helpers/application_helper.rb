module ApplicationHelper
	def initial_data_p1
		[ ['Item', 'Data'] , ['New Users', '1'], ['Orders', '1'], 
		  ['New Products', '1'], ['Revenue', '1'] ]
	end

	def initial_data_p2
		[ ['Item', 'User', 'Quantity'] , ['New Users', '1', '1'], 
		  ['Orders', '1', '1'], ['Item', 'User', 'Quantity'] , 
		  ['New Users', '1', '1'] ] 

	end
	def form_field_error_messages(resource, symbol)
		unless resource.errors[symbol].empty?
			"#{symbol.to_s.titleize} #{resource.errors[symbol].first}"
		end
	end
end
