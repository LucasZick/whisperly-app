import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisperly/providers/chats_provider.dart'; // Importe o ChatsProvider

class ChatHeader extends StatelessWidget {
  final ChatsProvider chatsProvider;

  const ChatHeader({super.key, required this.chatsProvider});

  @override
  Widget build(BuildContext context) {
    final currentChat = chatsProvider.chats
        ?.firstWhere((chat) => chat.chatId == chatsProvider.currentChatId);

    final username = currentChat?.contactUser.displayName ?? 'Username';

    return Container(
      height: 55,
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(currentChat?.contactUser.photoUrl ?? ""),
            ),
            const SizedBox(width: 10),
            Text(
              username,
              style: GoogleFonts.lato().copyWith(
                fontSize: 20,
                color: Theme.of(context).canvasColor,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
              color: Theme.of(context).canvasColor,
            )
          ],
        ),
      ),
    );
  }
}
