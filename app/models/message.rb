class Message < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  belongs_to :chat
  validates :chat_id, :content, :sender_id, :recipient_id, presence: true
end
