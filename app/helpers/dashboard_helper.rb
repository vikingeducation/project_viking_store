module DashboardHelper
  def analysis_days_in_words(number_of_days)
    words = number_of_days > 30 ? 'total' : "last #{number_of_days} days"

    words.titleize
  end

  def title_for(name, number_of_days)
    (number_of_days <= 30 ? "new #{name}" : name).titleize
  end

  def today_yesderday(date)
    if date.today?
      "Today"
    elsif date.tomorrow.today?
      "Yesterday"
    else
      date
    end
  end

  def sum_or_count(customer)
    customer.try(:count) || number_to_currency(customer.sum)
  end
end
