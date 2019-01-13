class Chat < ApplicationRecord
  has_many :messages
  belongs_to :user

  # This method takes one user argument and return the user they share the chat with
  def other_user(user)
    messages = self.messages.where("user_id != ?", user)
    return messages[0].user
    # I FEEL THIS METHOD COULD BE REWRITTEN IN A MORE EFFICIENT AND SUGAR WAY
  end
end
