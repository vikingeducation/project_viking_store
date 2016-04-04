class RemoveNullConstraintOnZipCodeForAddresses < ActiveRecord::Migration
  def change
    change_column :addresses, :zip_code, :integer, :null => true
  end
end
