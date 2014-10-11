class ChangeCategory < ActiveRecord::Migration
  def change
    change_table :categories do |t|
      t.remove :product_id
    end
  end
end
