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

  def messages_seen(data)
    if data['type'] == 'messages seen'
      contact_id = data['contact_id']
      ActionCable.server.broadcast "user_#{contact_id}", {
        type: data['type'],
        user_id: data['user_id'],
        contact_id: contact_id,
        chat_id: data['chat_id']
      }
    elsif data['type'] == 'messages seen PATCH'
      messages = Message.where("chat_id = ? AND recipient_id = ? AND seen = ?", data['chat_id'], data['user_id'], false)
      messages.each do |message|
        message.seen = true
        message.save
      end
    end
  end
end
