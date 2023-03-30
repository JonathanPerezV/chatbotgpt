enum ChatBotMessageType { user, bot }

class ChatModel {
  final String text;
  final ChatBotMessageType messageType;

  ChatModel({required this.text, required this.messageType});
}
