class MoreIndexes < ActiveRecord::Migration
  def change
    add_index :readings, :key
    add_index :readings, [:key, :room_id]
    add_index :readings, :created_at
    add_index :messages, :created_at
    add_index :homes, :is_public
  end
end
