import 'package:whisperly/models/user_model.dart';

enum MessageType { text, image }

class MessageModel {
  final String messageId;
  final String senderId;
  final UserModel? sender;
  final String? messageText;
  final String? imageUrl;
  final DateTime timestamp;
  final MessageType messageType;
  final String chatId;

  MessageModel({
    required this.messageId,
    required this.senderId,
    this.sender,
    this.messageText,
    this.imageUrl,
    required this.timestamp,
    required this.messageType,
    required this.chatId,
  });
}
