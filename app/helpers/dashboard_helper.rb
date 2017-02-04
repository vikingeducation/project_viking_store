module DashboardHelper

	include ApplicationHelper

	def initialize_tables
		@p1_table_7     	= initial_data_p1
		@p1_table_30    	= initial_data_p1
		@p1_table_total 	= initial_data_p1
		@p2_table_best_user = initial_data_p2
		@p3_table_7 		= initial_data_p1
		@p3_table_30 		= initial_data_p1
		@p3_table_total 	= initial_data_p1

		@p2_table_best_user[1][0] = 'Highest Single Order Value'
		@p2_table_best_user[2][0] = 'Highest Lifetime Value'
		@p2_table_best_user[3][0] = 'Highest Average Order Value'
		@p2_table_best_user[4][0] = 'Most Orders Placed'

		@p3_table_7[1][0] = 'Number of Orders'
		@p3_table_7[2][0] = 'Total Revenue'
		@p3_table_7[3][0] = 'Average Order Value'
		@p3_table_7[4][0] = 'Largest Order Value'

		@p3_table_30[1][0] = 'Number of Orders'
		@p3_table_30[2][0] = 'Total Revenue'
		@p3_table_30[3][0] = 'Average Order Value'
		@p3_table_30[4][0] = 'Largest Order Value'

		@p3_table_total[1][0] = 'Number of Orders'
		@p3_table_total[2][0] = 'Total Revenue'
		@p3_table_total[3][0] = 'Average Order Value'
		@p3_table_total[4][0] = 'Largest Order Value'
	end
end
