module DashboardHelper
  def analysis_days_in_words(number_of_days)
    words = number_of_days > 30 ? 'total' : "last #{number_of_days} days"

    words.titleize
  end

  def title_for(name, number_of_days)
    (number_of_days <= 30 ? "new #{name}" : name).titleize
  end
end
