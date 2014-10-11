class ChangeProducts2 < ActiveRecord::Migration
  def change
     change_table :products do |t|
      t.integer :category_id

     end
  end
end