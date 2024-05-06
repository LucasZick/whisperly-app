import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/providers/chats_provider.dart';
import 'package:whisperly/utils/validators.dart';

class ChatFooter extends StatelessWidget {
  ChatFooter({super.key});
  final TextEditingController messageController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void sendMessage(ChatsProvider chatsProvider) {
    if (formKey.currentState!.validate()) {
      chatsProvider.sendMessage(
          messageController.text, chatsProvider.currentChatId ?? "");
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    ChatsProvider chatsProvider = Provider.of<ChatsProvider>(context);
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formKey,
                child: TextFormField(
                  controller: messageController,
                  validator: (input) => Validators.validateMessage(input),
                  maxLines: 1,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    label: Text('Message'),
                    border: OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (input) {
                    sendMessage(chatsProvider);
                  },
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => sendMessage(chatsProvider),
            icon: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
