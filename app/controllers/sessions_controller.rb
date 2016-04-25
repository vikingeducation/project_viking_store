class SessionsController < ApplicationController

  layout 'front_facing'

  before_filter :store_referer, :only => [:new]

  # This should render your sign-in form!
  def new
  end

  # Sign in our user to create a new session
  # in this case, we'll assume that the user has
  # submitted their email address to sign in and
  # that's it (no password checking). This is
  # obviously very simpllistic and that's the idea
  def create
    user = User.find_by_email(params[:email])
    if user
      sign_in user
      flash[:notice] = "Thanks for signing in!"
      # If the user has shopping_cart_items then we're going to merge the items in that cart with the user's previous shopping cart.
      merge_shopping_carts(user) if session[:shopping_cart_items] && session[:shopping_cart_items].size > 0
      redirect_to referer
    else
      flash.now[:alert] = "We coudn't sign you in due to errors."
      render :new
    end
  end

  # Sign out our user to destroy a session
  def destroy
    if sign_out
      flash[:notice] = "You have successfully signed out"
      redirect_to root_path
    else
      flash[:alert] = "Angry robots have prevented you from signing out. You're stuck here forever."
      redirect_to root_path
    end
  end

  private

  # I felt weird about merging shopping carts here, however, the shopping cart for users that haven't signed in yet are in a session, so I think it's justifiable.
  # Not all currently registered users have shopping carts...
  # Because of the logic in the create method, we know that the current user has a pre sign-in shopping cart with at least one item... 
  def merge_shopping_carts(user)
    # I want to know if the user has a shopping cart already. If they don't, we can just pop the user_id on the current order and then pop the order id onto all the OrderContents and then save them...
    unless user.orders.where(:checkout_date => nil).first
      shopping_cart = Order.new(:user_id => user.id)
      shopping_cart.save
      # Now going through all the items in previous cart and adding this id
      add_session_products_to_merged_cart(shopping_cart.id)
    # if the user has a shopping cart already, then we can go through all the items that are in the session, check if they're already in the user's previous cart, and if they're not, then add them to that cart.
    # This makes me think that there was actually no reason to even build an initial cart because we coulda just built a cart if needed... murrrrrrr
    else
      # We need the order id for this user's previous shopping cart so that we can add it to the Order Contents in the sessions.
      # before we add it we need to make sure that the cart doesn't already have that item.
      # I'm pretty sure we can get an array of all the ids pretty easy and then do a include? on it - something like - Order.first.products.ids.include?(22145)
      ###### THIS WILL MEAN THAT IF A USER ALREADY HAD AN ITEM ON THEIR PREVIOUS SHOPPING CART, THE QUANTITY WILL STAY THE SAME INSTEAD OF CHANGING TO THE SESSION CARTS QUANTITY!
      previous_cart_id = user.orders.where(:checkout_date => nil).first.id
      previous_cart_product_ids = Order.find(previous_cart_id).products.ids
      session[:shopping_cart_items].each do |order_content|
        unless previous_cart_product_ids.include?(order_content["product_id"])
          order_content["order_id"] = previous_cart_id
          OrderContent.new(order_content).save
        end
      end
    end
    # delete session shopping cart and items
    session[:shopping_cart] = nil
    session[:shopping_cart_items] = nil
  end

  def add_session_products_to_merged_cart(shopping_cart_id)
    session[:shopping_cart_items].each do |order_content|
      order_content["order_id"] = shopping_cart_id
      OrderContent.new(order_content).save
    end
  end

  # this is one of those times when using a "delete" really comes in handy because it returns the object we want AND removes it from the hash in one operation.
  def referer
    session.delete(:referer)
  end

  def store_referer
    if request.referer
      session[:referer] = URI(request.referer).path
    else
      session[:referer] = root_path
    end
  end

end
