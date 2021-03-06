class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :messages
  validates :username, :photo, :email, presence: true
  validates :email, uniqueness: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  mount_uploader :photo, PhotoUploader

  Warden::Manager.before_logout do |user, auth, opts|
   user.status = Time.now
   user.save!
   user.broadcast_status
  end

  def after_database_authentication
    self.status = 'online'
    self.save!
    broadcast_status
  end

  def chats
    # Picks up chats that has messages where user is either a recipient or a sender
    chats = all_chats_including_self
    # Sorts chats from most recentl activity to oldest
    return chats.sort_by { |chat| chat.last_message.created_at }.reverse
  end

  def find_chat_with(user)
    # Returns chat current user share with 'user', or nil if there is none
    Chat.includes(:messages).where(messages: {recipient: self, sender: user }).or(Chat.includes(:messages).where(messages: {recipient: user, sender: self })).first
  end

  def unseen_chats_count
    # Returns the number of chats in which user has unseen messages
    # This could be rewritten in a more efficient query
    all_chats_including_self.select { |chat| chat.count_unseen_by(self) > 0 }.count

  end

  def broadcast_status
    # Broadcast status change to people wired to that user's channel
    ActionCable.server.broadcast("user_#{self.id}", {
      user_status_partial: ApplicationController.renderer.render(
        partial: 'chats/contact_status',
        locals: { contact: self }
      ),
      type: 'status change'
    })
  end

  private

  def all_chats_including_self
    Chat.includes(:messages).where(messages: {recipient: self }).or(Chat.includes(:messages).where(messages: {sender: self }))
  end
end
