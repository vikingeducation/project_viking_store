class DashboardController < ApplicationController

  def index

    # Overall Platform ( 7 days, 30 days, total )  [ item, data ]

      # list of all users
      # all orders
      # all new products
      # total revenue
    # users = User.select('Count(*) as user_count').where(:created_at <= 7.days.ago)
    # users = User.select('Count(*) as user_count').where(:created_at <= 30.days.ago)
    # users = User.select('Count(*) as user_count')

    @infographics = []
    sections = []
    sections <<  {
                    title: "Last 7 Days",
                    headers: ["Item", "Data"],
                    data: Overall.data(7)
                  }

    @infographics << {title: "1. Overall Platform", sections: sections}


    # User Demographics

      # Top 3 states with most users by billing address [ item, data ]
      # Top 3 cities with most users by billing address [ item, data ]

      # User with... [ item, name, quantity ]
        # most revenue in single order
        # most revenue generated over lifetime
        # highest average revenue per order
        # most orders placed


    # Order Stats ( 7 days, 30 days, total) [ item, data ]
      # number of orders
      # total revenue
      # average order value
      # largest order value

    # Time Series Data [ date, quantity, value ]
      # orders grouped by day (last 7)
      # orders grouped by week (last 7, date is first day of week)

  end

end
