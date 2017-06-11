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
    result =  ActiveRecord::Base.connection.exec_query(sql)
    if result.rows.count > 0
      return result.rows[0][0] || 0
    else
      return 0
    end
  end

  def self.count_current_carts
    return 7
  end
end
