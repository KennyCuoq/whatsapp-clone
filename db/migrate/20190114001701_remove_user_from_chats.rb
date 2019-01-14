class RemoveUserFromChats < ActiveRecord::Migration[5.2]
  def change
    remove_column :chats, :user_id
  end
end
