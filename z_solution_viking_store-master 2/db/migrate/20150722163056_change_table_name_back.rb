class ChangeTableNameBack < ActiveRecord::Migration
  def change
    rename_table(:order_content, :order_contents)
  end
end
