solution_viking_store
=====================

# Checkout





## Overview

This is it, the project that brought it all together. You had to implement the checkout process that allowed your users to place the orders they had in their carts. You also 


## Reviewing Your Solution

While reviewing your code ask the following questions:

* How did you set up your addresses to be created by public users? Did you use the same approach for public users?
* Did you use a callback in your model for shipping/billing? Perhaps `after_create`?
* Did you use nested attributes to allow addresses to be created through the new user form?
* How did you ensure that a user always has only one cart and that upon submission that cart is transformed into an order?
* How did you merge a cart for a visitor once they signed up or logged in?



## Introducing Our Solution

The relevant files for this solution section are in:

- `app/`
    - `controllers/`
        - `users_controller.rb`
        - `orders_controller.rb`
    - `views/`
        - `users/*`
        - `orders/*`

You may find that since your project is now in its finished state you'll want to review it with the entire solution app and possibly with linked student solutions in the main [README](README.md).



## Key Tips and Takeaways


1. **Accepting nested attributes for addresses in your `User` model allows you to create addresses from your user form.** This is a huge plus because now you can be certain that once a user is created that you have a usable address for them to place orders.

    ```ruby
    class User < ApplicationRecord

      has_many :addresses # don't destroy. want order records!
      
      #...

      # ":reject_if => :all_blank" keeps the blank form from failing validation.
      accepts_nested_attributes_for :addresses,
                                    :allow_destroy => true,
                                    :reject_if => :all_blank

      #...
    end
    ```

    ```erb
    <%= render "shared/errors", :object => @user %>

    <%= form_for @user do |user_fields| %>


      <%= user_fields.fields_for :addresses do |address_fields| %>
        <div class = "panel col-md-6 col-xs-12">
            <div class="form-group">
              <%= address_fields.label :street_address %>
              <%= address_fields.text_field :street_address, {class:"form-control"} %>
            </div>
            <div class="form-group">
              <%= address_fields.label :city_id %>
              <%= address_fields.text_field :city_id, {class:"form-control"} %>
            </div>

            <div class="form-group">
              <%= address_fields.collection_select :state_id, State.all, :id, :name, {prompt: "Pick a State"}, {:class => "form-control"} %>
            </div>

            <div class="form-group">
              <%= address_fields.label :zip_code %>
              <%= address_fields.text_field :zip_code, {class:"form-control"} %>
            </div>

            <div class="form-group">
              <%= user_fields.radio_button :billing_id, address_fields.index %>
              <%= address_fields.label :billing_address %>
            </div>

            <div class="form-group">
              <%= user_fields.radio_button :shipping_id, address_fields.index %>
              <%= address_fields.label :shipping_address %>
            </div>

            <% if address_fields.object.persisted? %>

              <div class="form-group">
                <%= address_fields.check_box :_destroy%>
                <%= address_fields.label :delete %>
              </div>

            <% end %>
        </div>

      <% end %>

    <div class = "panel col-md-6 col-xs-12">

      <div class="form-group">
        <%= user_fields.label :email %>
        <%= user_fields.email_field :email, {class:"form-control"}%>
      </div>

      <div class="form-group">
        <%= user_fields.label :confirm_email %>
        <%= user_fields.email_field :email, {class:"form-control"} %>
      </div>

      <div class="form-group">
        <%= user_fields.label :first_name %>
        <%= user_fields.text_field :first_name, {class:"form-control"} %>
      </div>
      <div class="form-group">
        <%= user_fields.label :last_name %>
        <%= user_fields.text_field :last_name, {class:"form-control"} %>
      </div>

    </div>

    <% if @user.persisted? %>
      <div class = "panel col-md-6 col-xs-12">
        <h3>Submit Changes</h3>
        <%= user_fields.submit "Edit Your Profile", {class: "btn btn-swedish btn-block"} %>
        <%= link_to("Delete my account", user_path(@user.id), method: "delete", data: {confirm: "Do you really want to quit this site when we know where you live and have axes?"})%>
      </div>
    <% else %>
      <div class = "panel col-md-6 col-xs-12">
        <h3>Complete Sign Up</h3>
        <%= user_fields.submit "Sign Up", {class: "btn btn-swedish btn-block"} %>
      </div>

    <% end %>



    <% end %>
    ```

1. **Checkout involved creating an order, this means merging that session cart into a real persisted order.** This depended on how you chose to implement your session cart. In the end, the concept is the same. The contents of the session must be transformed into an `Order` instance and saved.

    ```ruby
    class OrdersController < ApplicationController

      #...

      def create

        if current_user.cart.present?
          @order = current_user.cart
          @order.order_contents.destroy_all
        else
          @order = current_user.orders.build
        end

        session[:cart].each do |k, v|
          @order.order_contents.build(product_id: k,
                                 quantity: v)
        end

        @order.save!
        redirect_to edit_order_path(@order)
      end

      #...

    end
    ```


1. **One simple way of ensuring a cart always exists is with a simple `||=`.** This allows you to use the current cart if it exists in the session and create a new one if it does not.

    ```ruby
    class CartsController < ApplicationController

      def create
        session[:cart] ||= {}
        item = params[:item]

        if Product.exists?(item) && session[:cart][item]
          session[:cart][item] += 1
          flash[:success] = "Added another to your cart."
        elsif Product.exists?(item)
          session[:cart][item] = 1
          flash[:success] = "#{Product.find(item).name} added to cart!"
        else
          flash[:error] = "Product is invalid"
        end

        #...
    end
    ```



## Good Student Solutions

See this section in the main [README](README.md)

** NOTE:** *This solution repo is copyrighted material for your private use only and not to be shared outside of Viking Code School.*


