class CreateLocationUsers < ActiveRecord::Migration
  def change
    create_table :location_users do |t|
      t.belongs_to :user, null: false, index: true
      t.belongs_to :location, null: false
      t.boolean :is_public, default: false
      t.timestamps null: false
    end

    add_index :location_users, [:user_id, :location_id]

    add_foreign_key :location_users, :users
    add_foreign_key :location_users, :locations
  end
end
