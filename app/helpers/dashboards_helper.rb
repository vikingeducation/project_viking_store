module DashboardsHelper

  def week_str(num)
    case num
    when 0
     week_str = "This Week"
    when 1
     week_str = "Last Week"
    else
    week_str = "#{num} Weeks Ago"
    end
  end

  def day_str(num)
    case num
    when 0
     day_str = "Today"
    when 1
     day_str = "Yesterday"
    else
    day_str = ( DateTime.now - num ).to_s[0..9]
    end
  end

end
