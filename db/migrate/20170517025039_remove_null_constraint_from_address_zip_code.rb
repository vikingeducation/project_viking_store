class RemoveNullConstraintFromAddressZipCode < ActiveRecord::Migration[5.0]
  def change
    change_column_null(:addresses, :zip_code, true)
  end
end
