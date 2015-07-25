class DashboardController < ApplicationController

  def index
    # Assign arrays to the hash based on the starting values for the hash.
    @overall = User.get_overall

    @demographics = User.get_demographics

    @superlatives = User.get_superlatives

    @statistics = Order.get_statistics

    @days_series = get_filled_table(Order.time_series_day)

    @weeks_series = Order.time_series_week
  end

  def get_filled_table(table)
    results = []
    table.each do |row|
      row_hash = {}
      row_hash[:date] = row.day.to_date
      row_hash[:count] = row.count
      row_hash[:sum] = row.sum
      results << row_hash
    end

    dates_range = ((DateTime.now - 6).to_date..(DateTime.now).to_date)
    dates_range.each do |date|
      unless results.any?{|val| val.values.include?(date)}
        row_hash = {}
        row_hash[:date] = date
        row_hash[:count] = 0
        row_hash[:sum] = 0
        results << row_hash
      end
    end
    results = results.sort_by {|k| k[:date]}
    results.reverse
  end
end
