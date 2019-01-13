# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Destroy existing data
puts "Destroying existing data..."
Message.destroy_all
Chat.destroy_all
User.destroy_all
"Existing data destroyed!"
# Create users
puts "Creating users..."
sebastian = User.create!(email: 'sebastian@gmail.com', username: "Sebastian", password: '123456', remote_photo_url: 'https://storyteq.com/wp-content/uploads/2018/01/Square_avatar_Badr.jpg')
kenny = User.create!(email: 'kenny@gmail.com', username: "Kenny", password: '123456', remote_photo_url: 'https://avatars1.githubusercontent.com/u/26207944?v=4')
inou = User.create!(email: 'inou@gmail.com', username: "Inou", password: '123456', remote_photo_url: 'https://res.cloudinary.com/wagon/image/upload/c_fill,g_face,h_200,w_200/yzmhkgececsz46relki9.jpg')
puts "Users created!"
# Create chats
puts "Creating chats..."
chat = Chat.create!(user: kenny)
chat_2 = Chat.create!(user: sebastian)
chat_3 = Chat.create!(user: sebastian)
puts "Chat created!"
# Create messages
puts "Creating messages..."
conversation = ["Hello Kenny, how are you?", "I am great Seb thank you", "Very nice to hear Kenny, I wish you a good day", "And a good day to you too Seb!", "See you around friend", "Bye bye"]
conversation.each_with_index do |message, index|
  new_message = Message.new(chat: chat, content: message)
  index%2 == 0 ? new_message.user = sebastian : new_message.user = kenny
  new_message.save!
end
conversation = ["Hello Kenny, how are you?", "I am great Seb thank you", "Very nice to hear Kenny, I wish you a good day", "And a good day to you too Seb!", "See you around friend", "Bye bye"]
conversation.each_with_index do |message, index|
  new_message = Message.new(chat: chat_2, content: message)
  index%2 == 0 ? new_message.user = inou : new_message.user = sebastian
  new_message.save!
end
puts "Messages created!"
