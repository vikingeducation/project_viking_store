class DashboardController < ApplicationController

	include DashboardHelper

	def index
		initialize_tables

		populate_panel1_t1
		populate_panel1_t2
		populate_panel1_t3

		@p2_table_state = Address.get_state_demography
		@p2_table_city = Address.get_city_demography
		populate_panel2_t3

		@p3_table_7 = Order.get_past_week_table
		@p3_table_30 = Order.get_past_month_table
		@p3_table_total = Order.get_overall_table
	end

	def populate_panel1_t1
		@p1_table_7[1][1] = User.get_past_week
		@p1_table_7[2][1] = Order.get_past_week
		@p1_table_7[3][1] = Product.get_past_week
		@p1_table_7[4][1] = "$#{Order.get_past_week_revenue}"
	end

	def populate_panel1_t2
		@p1_table_30[1][1] = User.get_past_month
		@p1_table_30[2][1] = Order.get_past_month
		@p1_table_30[3][1] = Product.get_past_month
		@p1_table_30[4][1] = "$#{Order.get_past_month_revenue}"
	end

	def populate_panel1_t3
		@p1_table_total[1][1] = User.count
		@p1_table_total[2][1] = Order.placed.count
		@p1_table_total[3][1] = Product.count
		@p1_table_total[4][1] = "$#{Order.get_total_revenue}"
	end

	def populate_panel2_t3
	
		main_user = User.top_user_overall
		main_order = Order.top_order_overall
		avg_user = User.top_avg_user
		most_placed = User.most_order_user
		user_best_order = User.get_best_order_user(main_order.user_id)
		
		@p2_table_best_user[1][1] = "#{user_best_order.first_name} #{user_best_order.last_name}"
		@p2_table_best_user[1][2] = "$#{main_order.revenue.to_f}"

		@p2_table_best_user[2][1] = "#{main_user.first_name} #{main_user.last_name}"
		@p2_table_best_user[2][2] = "$#{main_user.revenue.to_f}"
		
		@p2_table_best_user[3][1] = "#{avg_user.first_name} #{avg_user.last_name}"
		@p2_table_best_user[3][2] = "$#{avg_user.avg.to_f}"

		@p2_table_best_user[4][1] = "#{most_placed.first_name} #{most_placed.last_name}"
		@p2_table_best_user[4][2] = "#{most_placed.count}"
	end
end