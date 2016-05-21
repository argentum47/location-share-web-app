class AddFieldsToUsersAndLocations < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, null: false
    add_column :locations, :address, :string, null: false
  end
end
