class AddSeenToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :seen, :boolean, :default => false
  end
end
