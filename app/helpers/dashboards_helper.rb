module DashboardsHelper
  def monthly(query)
    query.where("created_at > CURRENT_DATE - interval '30 day' ").count
  end

  def weekly(query)
    query.where("created_at > CURRENT_DATE - interval '7 day' ").count
  end

  def total(query)
   query.count
  end

  
end
