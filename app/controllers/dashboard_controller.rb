class DashboardController < ApplicationController

  def home
    @panels = []
    @panels << build_overall
    @panels
  end


  private


  def build_overall
    overall = {}
    overall[:title] = "Overall Platform"
    overall[:tables] = []

    total_table = {}
    total_table[:title] = "Total"
    total_table[:rows] = []
    total_table[:rows] << ["Users", User.count]
    total_table[:rows] << ["Orders", Order.submitted_count]
    total_table[:rows] << ["Products", Product.count]
    total_table[:rows] << ["Revenue", Order.total_revenue]

    overall[:tables] << total_table

    overall
  end

end
