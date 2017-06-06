class Product < ApplicationRecord
  def self.new_product_by_days(days)
    if days == 0
      sql = "select count(*)
      from products"
    else
      sql = "select count(*)
      from products
      where created_at >= current_date - " + days.to_s + " * interval '1 days'"
    end
    return ActiveRecord::Base.connection.exec_query(sql).rows[0][0]
  end
end
