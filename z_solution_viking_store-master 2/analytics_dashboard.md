solution_viking_store
=====================

# Analytics Dashboard





## Overview

This assignment pushed your SQL skills to the edge. Not only that but it forced you to wrap that SQL in useful and semantic model methods as well as tunnel that data through to your Rails views. There are no doubt parts of this assignment that feel against the grain and more difficult that is seems they should be. If that is your instinct, you're thinking on the right track! You'll find many of the raw SQL queries you wrote here can be translated into and simplified with Rails model features. But for now, doing it long hand has made your SQL writing that much stronger. Not many Rails developers dive this deep into writing raw SQL in there models!



## Reviewing Your Solution

While reviewing your solution you should ask the following questions:

* Is all of the logic for your SQL and database queries in your models?
* It is very possible you have a large controller method with many instance variables. However, are they just instance variables? Or are you running buisiness logic in your controllers that belongs in your models?
* Are you reusing queries? Are you plugging in dynamic values to the SQL? As long as they are YOUR dynamic values, SQL inject is not an issue and string interpolation for DRY SQL queries is a best practice!
* Did you section out reused joins into methods?
* Does your average order value add up properly? (`revenue = avg order value * num_orders`).
* Use the AVG( price * quantity ) in your select, group by order_id and you're golden.
* The fourth panel -- did you use SQL to output a single by-day table for the time series or did you end up making N SQL queries, one for each day/week?  Obviously better to do it all in 1 query then use Ruby to output the results.
* Did you refactor your joins into class methods?
* Did you add logic to handle `nil` returns and bad data in the view?


## Introducing Our Solution

To see the relevant parts of the solution for this assignment go to the following files:

- `app/`
    - `controllers/dashboard_controller.rb`
    - `models/*` (pay particular attention to the methods with raw SQL in them)
    - `views/dashboard/*`


## Key Tips and Takeaways

1. **Group your aggregate functions.** For example, when you wanted to find the states with top users, you had to `COUNT` them. This is an aggregate function. You wanted to count the number of users with a billing address that was in that particular state. So you had to `GROUP BY` state. This is actually the easy part, the difficult part was the joining addresses on states and users on addresses.

    ```ruby
    class State < ApplicationRecord

      # ...

      # JOINs the states to addresses and addresses to users, GROUPs the rows by state name, ORDERs them by user count, LIMITs the table to the first three records, and then SELECTs the state name and user count. The returned object has #state_name and #users_in_state methods.
      def self.three_with_most_users
        select("states.name AS state_name, COUNT(*) AS users_in_state").
          joins("JOIN addresses ON states.id = addresses.state_id JOIN users ON users.billing_id = addresses.id").
          order("users_in_state DESC").
          group("states.name").
          limit(3)
      end
    end
    ```

1. **For statistics across a table you'll have to user class methods.** If you wanted to gather information about one record you could use an instance, but because you want data about an entire table or groups of tables you have to use class methods.

    ```ruby
    @top_states = State.three_with_most_users
    @top_cities = City.three_with_most_users
    ```

    ```ruby
    class City < ApplicationRecord
      #...

      # JOINs the cities to addresses and addresses to users, GROUPs the rows by city name, ORDERs them by user count, LIMITs the table to the first three records, and then SELECTs the city name and user count. The returned object has #city_name and #users_in_city methods.
      def self.three_with_most_users
        select("cities.name AS city_name, COUNT(*) AS users_in_city").
          joins("JOIN addresses ON cities.id = addresses.city_id JOIN users ON users.billing_id = addresses.id").
          order("users_in_city DESC").
          group("cities.name").
          limit(3)
      end
    end
    ```

1. **If you `GROUP BY` without an aggregate function it does not help you.** You'll have to use an aggregate function to get `GROUP BY` to actually combine records with the same value for the column in the `GROUP BY` statement. For example if you `COUNT` cities and `GROUP BY` state it will show you a list of all the cities in that state. The same goes for more complex queries where you are performing math operations.


    ```ruby
    class Order < ApplicationRecord

      #...

      # This query is substantially the same as the one above, except WHERE screens for any checkout_date (which excludes "cart" orders that aren't checked out yet)."
        def self.all_time_largest_value
          select("orders.id, SUM(order_contents.quantity * products.price) AS value").
            joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
            where("checkout_date IS NOT NULL").
            order("value DESC").
            group("orders.id").
            first.
            value
        end

        #...
    end
    ```

1. **Use partials to separate large views like the analytics dashboard out into more modular pieces.** You could've done this in various different ways but one way is to section out the major parts of the dashboard into partials.

    ```erb
    <%= render partial: "overall",
                        locals: { users: @new_users[time_frame],
                                  orders: @new_orders[time_frame],
                                  products: @new_products[time_frame],
                                  revenue: @revenue[time_frame]} %>
    ```

    ```erb
    <table class="table table-striped table-bordered">
      <thead>
        <tr>
          <th>Item</th>
          <th>Data</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>New Users</td>
          <td>
            <%= users %>
          </td>
        </tr>
        <tr>
          <td>Orders</td>
          <td>
            <%= orders %>
          </td>
        </tr>
        <tr>
          <td>New Products</td>
          <td>
            <%= products %>
          </td>
        </tr>
        <tr>
          <td>Revenue</td>
          <td>
            <%= number_to_currency(revenue) %>
          </td>
        </tr>
      </tbody>
    </table>
    ```


## Good Student Solutions

See this section in the main [README](README.md)

** NOTE:** *This solution repo is copyrighted material for your private use only and not to be shared outside of Viking Code School.*






