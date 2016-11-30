class DashboardController < ApplicationController

  def index
    @overall_platform = {}
    @overall_platform[:last_7][:new_users] = get_new_user_count(7)
    @overall_platform[:last_7][:orders] = get_order_count(7)
    @overall_platform[:last_7][:new_products] = get_product_count(7)
    @overall_platform[:last_7][:revenue] = get_revenue(7)
  end
  
end
