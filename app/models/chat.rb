class Chat < ApplicationRecord
  has_many :messages
  belongs_to :user

  # This method takes one user argument and return the user they share the chat with
  def other_user(user)
    self.messages.each {|message| return message.user if message.user != user }
    # THIS METHOD CAN PROBABLY BE REWRITTEN SO AS TO GENERATE LESS SQL QUERIES
  end
end
