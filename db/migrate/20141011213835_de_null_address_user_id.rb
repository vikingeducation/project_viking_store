class DeNullAddressUserId < ActiveRecord::Migration
  def change
    change_column :addresses, :user_id, :integer, null: true
  end
end
