class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat
  validates :user_id, :chat_id, :content, presence: true
end
