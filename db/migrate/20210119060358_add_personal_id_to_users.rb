class AddPersonalIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :personal_id, :string
  end
end
