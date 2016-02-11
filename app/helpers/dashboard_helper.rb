module DashboardHelper

  def display_date(day)
    if day == Date.today
      "Today"
    elsif day == Date.today - 1
      "Yesterday"
    else
      "#{day.month}/#{day.day}"
    end
  end

  def display_week(week)
    "#{week.beginning_of_week.month}/#{week.beginning_of_week.day}"
  end
end
