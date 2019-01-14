class RemoveUserFromMessages < ActiveRecord::Migration[5.2]
  def change
    remove_column :messages, :user_id
  end
end
