import 'package:whisperly/models/message_model.dart';
import 'package:whisperly/models/user_model.dart';

class ChatModel {
  final String chatId;
  final List<UserModel> members;
  final List<String> membersUid;
  final List<MessageModel> messages;
  final UserModel contactUser;

  ChatModel({
    required this.chatId,
    required this.members,
    required this.membersUid,
    required this.contactUser,
    required this.messages,
  });
}
