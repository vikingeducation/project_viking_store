class ChangeOrderContentsModelName < ActiveRecord::Migration
  def change
    rename_table(:order_contents, :order_content)
  end
end
