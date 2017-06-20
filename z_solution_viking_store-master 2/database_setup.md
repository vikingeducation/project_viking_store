solution_viking_store
=====================

# Database Setup





## Overview

This assignment took you through creating the data model and seeds for your database. This is important. You had to think strategically about how your models are related and what schema best fits the needs of your application. Further, you had to think about how to represent orders and carts, locations and connect all of those to users in your schema. Next you had to seed that database.

You need to have records in your database that give your app data to work with while your developing your store. It is also important to make sure that your data is as accurate and close to the real thing as possible. This means you had to alter `created_at` times and simulate historical records.



## Reviewing Your Solution

While reviewing your solution you should ask the following questions:

### Data Modeling

* How do you represent carts and orders? Are they in different tables? Are they the same table? Why?
* How do you differentiate a place order from a cart? Did you use a boolean? Did you use a checkout date? How does this allow you to make the differentiation between cart and order?
* How do you represent addresses for users? How do you allow them to have multiple addresses?
* How do you allow users to have a shipping and billing address but keep those records in the addresses table?
* How do you represent quantities of products in order in your data model?


### Seeds

* Does your seeds file destroy all records before creating new ones?
* Do you create at least 100 users in your seeds?
* Did you set up a helper function to create random dates for `created_at` times ranging from some time in the past to now?
* Do users have multiple addresses? Are they staggered between the number of `0` and `5` for each user?
* Does each order have a separate shipping and billing address even though they might point to the same address?
* Do you have at least `5` to `10` states created?
* Did you create at least `10` to `30` products?
* Do you have at least `100` historical orders created? Do you use the same random date generating function to stagger `created_at` and `checkout_date` values?
* Did you show growth over time so that while creating users and orders your business grew over the course of months or years?
* Did you create at least `25` active shopping carts?
* Did you make all of this dynamic so you could scale up your database with a `MULTIPILER` constant?
* Did you create product quantities in your `OrderContent` join table/model?



## Introducing Our Solution

The solution for this assignment can be seen by examining the following files:

- `app/models/*`
- `db/`
    - `seeds.rb`
    - `schema.rb`


## Key Tips and Takeaways

1. **Orders and carts are the same thing, the only difference between them is one is checked out and one is not.** This can be represented by storing the `datetime` of the checkout. If the value is `NULL` then it is a cart. If there is a checkout date then it is a placed order.

    ```ruby
    create_table "orders", force: true do |t|
      t.datetime "checkout_date"
      t.integer  "user_id",        null: false
      t.integer  "shipping_id"
      t.integer  "billing_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "credit_card_id"
    end
    ```


1. **Addresses are best kept in a single table, to represent a billing and shipping address for users simply use different foreign key names for each.** You can then specify in Rails associations that `shipping_id` and `billing_id` point to addresses. You can also specify that a user has many addresses. This allows you to have multiple addresses for a user and still access specific addresses for billing and shipping.

    ```ruby
    class User < ApplicationRecord

      has_many :addresses # don't destroy. want order records!
      
      #...

      belongs_to :billing_address,
                  class_name: "Address",
                  :foreign_key => :billing_id

      belongs_to :shipping_address,
                  class_name: "Address",
                  :foreign_key => :shipping_id

      #...

    end
    ```

    ```ruby
    create_table "addresses", force: true do |t|
      t.string   "street_address",    null: false
      t.string   "secondary_address"
      t.integer  "zip_code",          null: false
      t.integer  "city_id",           null: false
      t.integer  "state_id",          null: false
      t.integer  "user_id",           null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    #...

    create_table "users", force: true do |t|
      t.string   "first_name",  null: false
      t.string   "last_name",   null: false
      t.string   "email",       null: false
      t.integer  "billing_id"
      t.integer  "shipping_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    ```

1. **Create a `JOIN` model for your order contents.** This allows you to specify a qunatity for each product and the order to which it belongs.

    ```ruby
    class OrderContent < ApplicationRecord
      belongs_to :order
      belongs_to :product

      #...
    end
    ```

    ```ruby
    create_table "order_contents", force: true do |t|
      t.integer  "order_id",               null: false
      t.integer  "product_id",             null: false
      t.integer  "quantity",   default: 1, null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    ```

1. **Destroy all the records before you begin seeding.** This will ensure you start your database with a clean slate each time. You wouldn't want to endlessly bloat your database will old records from seeds. In many cases you'll have unique constraints that will require this.

    ```ruby
    User.destroy_all
    Address.destroy_all
    Order.destroy_all
    OrderContent.destroy_all
    Category.destroy_all
    CreditCard.destroy_all
    Product.destroy_all
    State.destroy_all
    City.destroy_all
    ```

1. **Use a helper method in your seeds to generate a creation date for your records.** This allows you to generate seed data that mimics join times throughout a historical time period.

    ```ruby
    # This method returns a random date
    def creation_date
      time_frames = []
      (MULTIPLIER**2).times do |x|
         time_frames << midnight_tonight - ((x*3) + 1).month
      end
      date_range = (time_frames.sample..midnight_tonight)
      rand(date_range)
    end
    ```


    ```ruby
    u = User.new
    u[:first_name]  = first_name
    u[:last_name]   = last_name
    u[:email]       = Faker::Internet.email("#{first_name} #{last_name}")
    u[:created_at]  = creation_date
    u.save
    ```




## Good Student Solutions

* [Chris Scavello's Solution](https://github.com/BideoWego/assignment_viking_store/)
* [Kit Langton's Solution](https://github.com/kitlangton/assignment_viking_store)
* [Dustin Lee's Solution](https://github.com/leedu708/assignment_viking_store)



** NOTE:** *This solution repo is copyrighted material for your private use only and not to be shared outside of Viking Code School.*








