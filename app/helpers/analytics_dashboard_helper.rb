module AnalyticsDashboardHelper

  def formatted_date(day_obj)
    date = day_obj.date
    if date == Date.today
      'Today'
    elsif date == Date.yesterday
      'Yesterday'
    else
      date.strftime '%-m/%l'
    end
  end
end