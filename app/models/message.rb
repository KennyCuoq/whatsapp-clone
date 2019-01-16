class Message < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  belongs_to :chat
  validates :chat_id, :sender_id, :recipient_id, presence: true
  validates :content, presence: true, allow_blank: false

  def sent_by(user)
    sender == user
  end

  def unseen?
    !seen
  end

  def time
    created_at.strftime("%H:%M")
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
end
