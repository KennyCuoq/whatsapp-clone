class UsersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_#{params[:user_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def typing(data)
    recipient_id = data['recipient_id']
    ActionCable.server.broadcast "user_#{recipient_id}", {
      type: data['type'],
      sender_id: data['sender_id'],
      recipient_id: recipient_id,
      chat_id: data['chat_id']
    }
  end
end
