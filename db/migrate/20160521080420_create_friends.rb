class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.belongs_to :user, null: false, index: true
      t.integer :friend_id, null: false, index: true
      t.timestamps null: false
    end

    add_index :friends, [:user_id, :friend_id], unique: true
    add_foreign_key :friends, :users, dependent: :delete
    add_foreign_key :friends, :users, column: :friend_id, dependent: :delete
  end
end
