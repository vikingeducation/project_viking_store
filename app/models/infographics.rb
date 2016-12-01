class Infographics

  def self.get_panels
    [
      {
        title: "1. Overall Platform",
        sections: [
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
      },
      {
        title: "2. User Demographics and Behavior",
        sections: [
                    {
                      title: "Top 3 States Users Live In (billing)",
                      headers: ["Item", "Data"],
                      data: UserDemographics.location_demo('state')
                    },
                    {
                      title: "Top 3 Cities Users Live In (billing)",
                      headers: ["Item", "Data"],
                      data: UserDemographics.location_demo('city')
                    },
                    {
                      title: "Top User With...",
                      headers: ["Item", "User", "Quantity"],
                      data: UserDemographics.extremist_users
                    }
                  ]
      },
      {
        title: "3. Order Statistics",
        sections: [
                    {
                      title: "Last 7 Days",
                      headers: ["Item", "Data"],
                      data: OrderStats.data(7)
                    },
                    {
                      title: "Last 30 Days",
                      headers: ["Item", "Data"],
                      data: OrderStats.data(30)
                    },
                    {
                      title: "Total",
                      headers: ["Item", "Data"],
                      data: OrderStats.data
                    }
                  ]
      },
      {
        title: "4. Time Series",
        sections: [
                    {
                      title: "Orders By Day",
                      headers: ["Date", "Quantity", "Value"],
                      data: TimeSeries.data(1)
                    },
                    {
                      title: "Orders By Week",
                      headers: ["Date", "Quantity", "Value"],
                      data: TimeSeries.data(7)
                    }
                  ]
      }
    ]
  end

end
