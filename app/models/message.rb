class Message < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  belongs_to :chat
  validates :chat_id, :sender_id, :recipient_id, presence: true
  validates :content, presence: true, allow_blank: false
  after_create :broadcast_message

  def sent_by?(user)
    sender == user
  end

  def broadcast_message
    # To recipient's 'Chat show'
    ActionCable.server.broadcast("user_#{recipient.id}", {
      unseen_chat_count_partial: ApplicationController.renderer.render(
        partial: 'chats/unseen_chat_count',
        locals: { user: self.recipient }
      ),
      message_partial: ApplicationController.renderer.render(
        partial: 'messages/message',
        locals: { message: self, was_sent_by_user: false }
      ),
      user_status_partial: ApplicationController.renderer.render(
        partial: 'chats/contact_status',
        locals: { contact: self.sender }
      ),
      chat_id: chat.id,
      type: 'new message'
    })
    # To recipient's dashboard
    ActionCable.server.broadcast("user_#{recipient.id}", {
      chat_partial: ApplicationController.renderer.render(
        partial: 'menu/chat_card',
        locals: { chat: self.chat, user: self.recipient }
      ),
      chat_id: chat.id,
      type: 'new message (chat-card)'
    })
    # To sender's dashboard
    ActionCable.server.broadcast("user_#{sender.id}", {
      chat_partial: ApplicationController.renderer.render(
        partial: 'menu/chat_card',
        locals: { chat: self.chat, user: self.sender }
      ),
      chat_id: chat.id,
      type: 'new message (chat-card)'
    })
  end

  def unseen?
    !seen
  end

  def time
    created_at.strftime("%H:%M")
  end

  def preceded_by_message_from_other_user?
    # Find previous message in conversation
    previous_message = Message.where("chat_id = ? AND id < ?", self.chat, self.id).order(id: :desc).first
    # Checks that there is a previous message and
    # Returns true if sender of previous message is not the sender of self
    previous_message.nil? ? false : previous_message.sender != self.sender
  end

  def previous_message_sent_on_different_day?
    previous_message = Message.where("chat_id = ? AND id < ?", self.chat, self.id).order(id: :desc).first
    previous_message.nil? ? true : self.date_stamp != previous_message.date_stamp
  end

  def last_of_series?
    # Find next message in the conversation
    next_message = Message.where("chat_id = ? AND id > ?", self.chat, self.id).order(id: :asc).first
    # Checks whether the message is the last of the user's series or if the message is the very last of the chat
    next_message.nil? ? true : next_message.from_other_user?(self.sender)
  end

  def from_other_user?(user)
    self.sender != user
  end

  def date
    time = created_at
    date = time.to_date
    if date == Date.today
      # Returns time eg 15:08 if today
      self.time
    elsif date == Date.today - 1
      # Returns 'yesterday' if yesterday
      'Yesterday'
    elsif date > (Date.today - 7)
      # Returns day of week eg 'Tuesday' if older than yesterday
      time.strftime("%A")
    else
      # Returns date in format 31/12/18 if older than a week
      time.strftime("%d/%m/%Y")
    end
  end

  # This method is similar to 'date' but it serves to separate chats#show in days, does not return exactly the same thing
  def date_stamp
    time = created_at
    date = time.to_date
    if date == Date.today
      'Today'
    elsif date == Date.today - 1
      # Returns 'yesterday' if yesterday
      'Yesterday'
    elsif date > (Date.today - 7)
      # Returns day of week eg 'Tuesday' if older than yesterday
      time.strftime("%A")
    else
      # Returns date in format Sun 9 Jan  if older than a week
      time.strftime('%a %e %b')
    end
  end
end
