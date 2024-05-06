import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/models/chat_model.dart';
import 'package:whisperly/models/message_model.dart';
import 'package:whisperly/providers/chats_provider.dart';
import 'package:whisperly/widgets/message_box.dart';
import 'package:whisperly/widgets/no_items_warning.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChatsProvider chatsProvider = Provider.of<ChatsProvider>(context);
    return Expanded(
      child: StreamBuilder<ChatModel?>(
        stream: Provider.of<ChatsProvider>(context).currentChatStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            final ChatModel? currentChat = snapshot.data;
            final List<MessageModel> messages = currentChat?.messages ?? [];

            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.minScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              },
            );

            return chatsProvider.isChatLoading
                ? const Center(child: CircularProgressIndicator())
                : messages.isNotEmpty
                    ? ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return MessageBox(
                            message: message,
                          );
                        },
                      )
                    : const Center(
                        child: NoItemsWarning(itemType: "messages"),
                      );
          }
        },
      ),
    );
  }
}
