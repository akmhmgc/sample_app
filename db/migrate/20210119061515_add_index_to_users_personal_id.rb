class AddIndexToUsersPersonalId < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :personal_id, unique: true
  end
end
