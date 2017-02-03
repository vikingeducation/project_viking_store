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
end
