class DashboardController < ApplicationController

  def index
    # Assign arrays to the hash based on the starting values for the hash.
    @overall = User.get_overall

    @demographics = User.get_demographics

    @superlatives = User.get_superlatives

    @statistics = Order.get_statistics

    @days_series = Order.time_series_day

    @weeks_series = Order.time_series_week
  end

  def get_filled_table(table)
    results = []
    table.each do |row|
      results << row.date.to_date
    end
    dates_range = ((DateTime.now - 7).to_date..(DateTime.now).to_date)
    dates_range.each do |date|
      unless results.include?(date)
        
  end
end
