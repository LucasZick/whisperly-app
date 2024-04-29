import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/providers/chats_provider.dart';
import 'package:whisperly/widgets/chat.dart';
import 'package:whisperly/widgets/chat_footer.dart';
import 'package:whisperly/widgets/chat_header.dart';

class ChatField extends StatelessWidget {
  const ChatField({super.key});

  @override
  Widget build(BuildContext context) {
    double frameWidth = MediaQuery.of(context).size.width;
    double frameHeight = MediaQuery.of(context).size.height;
    ChatsProvider chatsProvider = Provider.of<ChatsProvider>(context);
    return SizedBox(
      width: 7 / 10 * frameWidth,
      height: frameHeight,
      child: SizedBox(
        child: Column(
          children: [
            ChatHeader(chatsProvider: chatsProvider),
            const Chat(),
            ChatFooter(chatsProvider: chatsProvider),
          ],
        ),
      ),
    );
  }
}
