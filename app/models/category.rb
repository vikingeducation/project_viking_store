class Category < ActiveRecord::Base

  def self.all
    rows = []
    Product.find_by_sql("SELECT * FROM categories").each do |category|
      row = []
      row << category.id
      row << category.name
      row << category.description
      row << category.created_at
      row << category.updated_at
      rows << row
    end
    rows
  end

  def self.column_names
    Product.find_by_sql("SELECT * FROM information_schema.columns where table_name='categories'")
  end

end
