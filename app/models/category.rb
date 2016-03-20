class Category < ActiveRecord::Base

  validates :name,
            :length => {:in => 4..16}

  def self.all
    rows = []
    Category.find_by_sql("SELECT * FROM categories").each do |category|
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

=begin

  I think this method is causing me a lot of deadlock, recursive locking issues even though I have no idea why.

  def self.column_names
    Product.find_by_sql("SELECT * FROM information_schema.columns where table_name='categories'")
  end
=end

end
