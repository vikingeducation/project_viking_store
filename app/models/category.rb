class Category < ActiveRecord::Base

  def self.column_names
    Product.find_by_sql("SELECT * FROM information_schema.columns where table_name='categories'")
  end

end
