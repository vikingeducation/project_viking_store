solution_viking_store
=====================

# Admin Backend





## Overview

This assignment took you through using all that you've learned so far about Rails forms. You got to CRUD all of you resources in the Viking Store from the POV of a site administrator. This as you can imagine is much different to implement that user facing CRUD. You had to really allow detailed management of all your resources.



## Reviewing Your Solution

As you review your code ask yourself the following questions:

### Part 1

* Did you setup both Rails and database level validations?
* What is the importance of both? Why would you want both and not just one or the other?
* Can you explain how Rails creates join tables from the associations you used?
* Did you notice that in using associations some of your analytics queries could've been done differently?
* How do you rename an association?
* How does Rails know the table name and foreign key?

### Part 2

* How did you set up your `form_for` and controllers to allow order contents to be created from the same page as an order?
* How did you set up your addresses to be created and for a user to select if that address is their billing and/or shipping? Did you use a dropdown? Checkboxes? Radoi buttons?
* Did you wait for an address to be created and then allow them to choose? Or did you allow it during creation?



## Introducing Our Solution

The admin portal is stretched across 2 assignments. This README will handle both.


Although namespacing is not covered until a later unit, this solution is in the state of the final project. As such, you'll to navigate to the files in their final directories and this will likely differ from where they are in your current project. This means relevant files will be under `admin/` folders.

- `app/`
    - `controllers/admin*`
    - `models/*`
    - `views/admin/*`




## Key Tips and Takeaways

1. **Set both Rails and database level validations.** Rails validations prevent invalid records from being created through your app and provides the user with helpful feedback when they pass invalid data to your forms. Database level validations prevent corrupt data from being created in your database from race conditions and potential flaws in your Rails app. One place you wanted to do this was to keep products unique to their order. A product may only be associated with an order once, after that it is the quantity of the product that changes.

    ```ruby
    add_index "order_contents", ["order_id", "product_id"], name: "index_order_contents_on_order_id_and_product_id", unique: true
    ```

    ```ruby
    class OrderContent < ApplicationRecord


      belongs_to :order
      belongs_to :product

      # for any ONE order, a product ID should only appear once
      validates :product_id, uniqueness: { scope: :order_id }

      #...
    end
    ```

1. **Use associations where ever you can to create relationships between your models and easy access to relevant records throughout your application.** You would expect to be able to ask an order for its products, you'd expect to ask a user for it's orders, you'd expect to ask a user for it's shipping and billing addresses and be able to chain on to them methods to get at the state, city and zip code. All of these are done through associations.

    ```ruby
    class Order < ApplicationRecord


      belongs_to :user, foreign_key: :user_id

      belongs_to :shipping_address,
                 foreign_key: :shipping_id,
                 class_name: "Address"

      belongs_to :billing_address,
                 foreign_key: :billing_id,
                 class_name: "Address"

      has_many :order_contents
      has_many :products, through: :order_contents

      #...
    end
    ```

    ```ruby
    class User < ApplicationRecord

      has_many :addresses # don't destroy. want order records!
      has_many :orders
      has_many :credit_cards, dependent: :destroy

      has_many :products, through: :order_contents

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
    class Address < ApplicationRecord

      belongs_to :user
      belongs_to :state
      belongs_to :city

      has_many :orders_billed_here,
               class_name: "Order",
               foreign_key: :billing_id

      has_many :orders_shipped_here,
               class_name: "Order",
               foreign_key: :shipping_id

      #...
    end
    ```

1. **To add order contents to an order you had to create an `OrderContentsController`.** If you tried to do this another way you most likely had a solution that had a similar outcome but was an extra method or two in a controller in which it did not belong.


    ```ruby
    class Admin::OrderContentsController < AdminController
      def create
        if Purchase.create(create_purchase_params.values)
          flash[:success] = "New contents added to order."
          redirect_to orders_path
        else
          flash.now[:error] = "Failed to add order contents."
          render :index # not sure about this one
        end
      end

      def update
        if Purchase.update(update_purchase_params.keys, update_purchase_params.values)
          flash[:success] = "Order contents updated."
          redirect_to orders_path
        else
          flash.now[:error] = "Order contents failed to update."
          render :index # not sure about this one
        end
      end

      def destroy
      end

      private

      def update_purchase_params
        params.require(:purchases)
      end
    end
    ```

1. **Many of these forms will be built upon and adapted in coming lessons.** The key takeaway here is to see roughly how basic forms are put together using `form_for` and how they tunnel data through the controller's strong parameters to the model. The more complex problems like order contents and addresses will be covered in detail in later units. Here are a few examples how well put together forms. Note that because the final solution is namespaced under `admin` that the `form_for` will have an array with `:admin` and the resource name. Don't worry about this until you learn in later.

    ```erb
    <div class="row">
      <div class="col-md-6">
        <%= render "admin/shared/errors", :object => category %>

        <%= form_for [:admin, category], {:html => {:class => "form-horizontal" }} do |f| %>

          <h3><%= form_type %> Category</h3>

          <div class="form-group">
            <%= f.label "Category ID:", :class => "col-md-3 control-label" %>
            <div class="col-md-9">
              <%= display_if(category.id) %>
            </div>
          </div>

          <div class="form-group">
            <%= f.label :name, :class => "col-md-3 control-label" %>
            <div class="col-md-9">
              <%= f.text_field :name, placeholder: "enter the category name here", :class => "form-control" %>
            </div>
          </div>

          <%= f.submit submit(form_type, "Category"), :class => "btn btn-large btn-primary btn-block" %>
        <% end %>
        <%= (link_to "Delete Category", admin_category_path(@category), :method => :delete, :data => { confirm: "Are you sure?" }) if category.id %>
      </div>
    </div>
    ```

    ```erb
    <div class="row">
      <div class="col-md-6">
        <%= render "admin/shared/errors", :object => product %>

        <%= form_for [:admin, product], {:html => {:class => "form-horizontal" }} do |f| %>
          <h3><%= form_type %> product</h3>
          <div class="form-group">
            <%= f.label "Product ID:", :class => "col-md-3 control-label" %>
            <div class="col-md-9">
              <%= display_if(product.id) %>
            </div>
          </div>

          <div class="form-group">
            <%= f.label :name, :class => "col-md-3 control-label" %>
            <div class="col-md-9">
              <%= f.text_field :name, placeholder: "enter the product name here", :class => "form-control" %>
            </div>
          </div>

          <div class="form-group">
            <%= f.label :price, :class => "col-md-3 control-label" %>
            <div class="col-md-9">
              <div class="input-group">
                <span class="input-group-addon">$</span>
                <%= f.text_field :price, placeholder: "enter the price here", :class => "form-control" %>
              </div>
            </div>
          </div>

          <div class="form-group">
            <%= f.label :sku, :class => "col-md-3 control-label" %>
            <div class="col-md-9">
              <%= f.text_field :sku, placeholder: "enter the sku here", :class => "form-control" %>
            </div>
          </div>

          <div class="form-group">
            <%= f.label :category_id, :class => "col-md-3 control-label" %>
            <div class="col-md-9">
              <%= f.collection_select :category_id, Category.all, :id, :name, {}, :class => "form-control" %>
            </div>
          </div>

          <%= f.submit submit(form_type, "Product"), :class => "btn btn-large btn-primary btn-block" %>
        <% end %>

        <%= (link_to "Delete Product", admin_product_path(@product), :method => :delete, :data => { confirm: "Are you sure?" }) if product.id %>
      </div>
    </div>
    ```


## Good Student Solutions

See this section in the main [README](README.md)

** NOTE:** *This solution repo is copyrighted material for your private use only and not to be shared outside of Viking Code School.*






