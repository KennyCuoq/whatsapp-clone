function removePreviousBubbleArrow() {
  const allMessages = document.querySelectorAll('.bubble')
  const lastMessage = allMessages[allMessages.length-1]
  if (!lastMessage.classList.contains('sent')) {
    const bubbleArrow = lastMessage.lastElementChild;
    console.log('heyyyy');
    bubbleArrow.remove();
  }
  console.log('ehy');
}
scrollLastMessageIntoView();
App['chat_<%= @chat.id %>'] = App.cable.subscriptions.create({ channel: 'ChatsChannel', chat_id: <%= @chat.id %> }, {
  received: (data) => {
    if (data.current_user_id !== <%= @user.id %>) {
      const messagesContainer = document.querySelector('.container-messages');
      removePreviousBubbleArrow();
      messagesContainer.insertAdjacentHTML('beforeend', data.message_partial);
      scrollLastMessageIntoView();
    }
  }
})
