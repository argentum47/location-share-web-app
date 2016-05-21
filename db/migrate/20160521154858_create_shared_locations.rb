class CreateSharedLocations < ActiveRecord::Migration
  def change
    create_table :shared_locations do |t|
      t.belongs_to :friend, null: false, index: true
      t.belongs_to :location_user, null: false
      t.timestamps null: false
    end

    add_foreign_key :shared_locations, :users, column: :friend_id, dependent: :delete
  end
end
