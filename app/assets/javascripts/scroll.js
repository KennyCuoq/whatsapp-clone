function scrollLastMessageIntoView() {
  const messages = document.querySelectorAll('.message-wrapper');
  const lastMessage = messages[messages.length - 1];

  if (lastMessage !== undefined) {
    lastMessage.scrollIntoView();
  }
}
