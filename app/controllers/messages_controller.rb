class MessagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:home]
  skip_after_action :verify_authorized, only: [:create]


  def create
    # binding.pry
    # If user tries to make new convo with someone who they already have a convo with they should be redriecte to that chat they already ha
    # binding.pry
    if comes_from_chat_show
      # This is if the message is being created directly from an existing chat
      @message = Message.new(content: message_params[:content])
      @chat = Chat.find(message_params[:chat_id])
      @message.recipient = User.find(message_params[:recipient_id])
    else
      # The below handles the different scenarios if the user adds a contact from dashboard
      contact = User.find_by_username(message_params[:recipient])
      if contact.nil?
        # If they entered an invalid username
        redirect_to root_path
        return
      else
        chat = contact.find_chat_with(current_user)
        if !chat.nil?
          # If they already have a chat with that person
          redirect_to chat_path(chat)
          return
        else
          # If this is a valid add-contact request
          @message = Message.new(content: "Hey there! I am using WhatsUpp.")
          @chat = Chat.create
          @message.recipient = contact
        end
      end
    end
    @message.chat = @chat
    @message.sender = current_user
    if @message.save
      respond_to do |format|
        format.html { redirect_to chat_path(@chat) }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
    # NEED TO FIGURE OUT HOW TO SET UP PUNDIT FOR THIS, KEEP GETTING 'not allowed to create?'
    # authorize @message
  end

  private

  def message_params
    params.require(:message).permit(:content, :recipient_id, :chat_id, :recipient)
  end

  def comes_from_chat_show
    message_params[:content].present? && message_params[:chat_id].present? && message_params[:recipient_id].present?
  end
end
