class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :follower_id, null: false, index: true
      t.integer :followed_id, null: false, index: true
      t.timestamps null: false
    end

    add_index :friends, [:follower_id, :followed_id], unique: true
    add_foreign_key :friends, :users, column: :followed_id
    add_foreign_key :friends, :users, column: :follower_id
  end
end
