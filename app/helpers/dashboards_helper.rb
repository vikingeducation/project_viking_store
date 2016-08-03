module DashboardsHelper

  def get_all_time_totals
    all_time_totals = {}
    all_time_totals["Users"] = User.count
    all_time_totals["Orders"] = 

  end

end
