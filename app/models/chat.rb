class Chat < ApplicationRecord
  has_many :messages

  # This method takes one user argument and return the user they share the chat with
  def other_user(user)
    # messages = self.messages.where("user_id != ?", user)
    # return messages[0].user
    message = self.messages.first
    message.sender == user ? message.recipient : message.sender
    # I FEEL THIS METHOD COULD BE REWRITTEN IN A MORE EFFICIENT AND SUGAR WAY
  end

  def last_message
    # Returns a chat's last message
    messages.order(:created_at).last
  end

  def unseen_messages?
    last_message.seen
  end

  def unseen_count
    # Returns the number of unseen messages where recipient is user

  end
end
