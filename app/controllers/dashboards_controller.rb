class DashboardsController < ApplicationController

  def index
    last7 = 7.days.ago.to_date
    new_users = User.find_by_sql("SELECT count(*) \
      FROM users WHERE created_at <= #{last7}")

    User.where()

    #method to get data
    #dataform = {}
    # dataform[title]= AR relations obj
    # AR rel obj ~ array
    # section_data ={'last7': [data], 'last30': [data], ...}

    #pass 4 diff. section_data as 4 variables to view
  end

end
