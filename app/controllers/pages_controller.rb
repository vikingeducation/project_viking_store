class PagesController < ApplicationController

  def admin
  end

  def dashboard

    @total_user_count = User.count
    @total_order_count = Order.count
    @total_product_count = Product.count
    @total_revenue_past_7_days = total_revenue_last_n_days(7)
    @total_revenue_past_30_days = total_revenue_last_n_days(30)

    @highest_value_order ||= Order.highest_value


  end

  private

  def total_revenue_last_n_days(n)
    @total_revenue_last_n_days ||= Order.last_n_days(n).total_revenue
  end

  def new_users_past_7_days
    @new_users_past_7_days ||= User.last_n_days(7).count
  end
  helper_method :new_users_past_7_days

  def new_users_past_30_days
    @new_users_past_30_days ||= User.last_n_days(30).count
  end
  helper_method :new_users_past_30_days

  def new_orders_past_7_days
    @new_orders_past_7_days ||= Order.last_n_days(7).count
  end
  helper_method :new_orders_past_7_days

  def new_orders_past_30_days
    @new_orders_past_30_days ||= Order.last_n_days(30).count
  end
  helper_method :new_orders_past_30_days

  def new_products_past_7_days
    @new_products_past_7_days ||= Product.last_n_days(7).count
  end
  helper_method :new_products_past_7_days

  def new_products_past_30_days
    @new_products_past_30_days ||= Product.last_n_days(30).count
  end
  helper_method :new_products_past_30_days

  def total_revenue
    @total_revenue ||= Order.total_revenue
  end
  helper_method :total_revenue

  def top_states
    @top_states ||= State.three_with_most_users
  end
  helper_method :top_states

  def top_cities
    @top_cities ||= City.three_with_most_users
  end
  helper_method :top_cities

  # def highest_value_order
  #   @highest_value_order ||= Order.highest_value
  # end
  # helper_method :highest_value_order

  def user_lifetime_highest
    @user_lifetime_highest ||= User.highest_lifetime_value
  end
  helper_method :user_lifetime_highest


end
