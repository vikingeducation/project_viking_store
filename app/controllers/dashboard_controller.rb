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
    overall_sections = [
                          {
                            title: "Last 7 Days",
                            headers: ["Item", "Data"],
                            data: OverallPlatform.data(7)
                          }, 
                          {
                            title: "Last 30 Days",
                            headers: ["Item", "Data"],
                            data: OverallPlatform.data(30)
                          },
                          {
                            title: "Total",
                            headers: ["Item", "Data"],
                            data: OverallPlatform.data
                          }
                        ]

    @infographics << { title: "1. Overall Platform", sections: overall_sections }


    # User Demographics

      # Top 3 states with most users by billing address [ item, data ]
      # Top 3 cities with most users by billing address [ item, data ]

      user_demo_sections = [
                            {
                              title: "Top 3 States Users Live In (billing)",
                              headers: ["Item", "Data"],
                              data: UserDemographics.location_demo('state')
                            },
                            {
                              title: "Top 3 Cities Users Live In (billing)",
                              headers: ["Item", "Data"],
                              data: UserDemographics.location_demo('city')
                            }
                          ]

      @infographics << { title: "2. User Demographics and Behavior", sections: user_demo_sections }

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
