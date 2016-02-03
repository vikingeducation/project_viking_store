class DashboardController < ApplicationController
  include Analytics

  def index
    begin_time = Time.now
    puts "Begin time: #{begin_time}"

    panel_one
    panel_two
    panel_three
    panel_four
    panel_five

    end_time = Time.now
    puts "Time taken is #{end_time - begin_time}."
  end

  def get
  end



end
