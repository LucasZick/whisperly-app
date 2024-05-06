import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/models/chat_model.dart';
import 'package:whisperly/providers/chats_provider.dart';
import 'package:whisperly/providers/user_data_provider.dart';

class ContactListTile extends StatelessWidget {
  const ContactListTile({super.key, required this.chat});
  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    ChatsProvider chatsProvider = Provider.of<ChatsProvider>(context);
    UserDataProvider userDataProvider = Provider.of<UserDataProvider>(context);

    String lastMessageText = chat.messages.isEmpty
        ? "This chat has no messages"
        : "${chat.messages.lastOrNull?.senderId == userDataProvider.currentUser?.uid ? "You" : chat.contactUser.displayName}: ${chat.messages.lastOrNull!.messageText}";

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(chat.contactUser.photoUrl ?? ""),
      ),
      trailing: CircleAvatar(
        radius: 5,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        chat.contactUser.displayName ?? "Contact",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        lastMessageText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => chatsProvider.setCurrentChat(chat.chatId),
    );
  }
}


/*PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (String value) {
                switch (value) {
                  case 'arquivar':
                    break;
                  case 'limpar':
                    break;
                  case 'remover':
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'arquivar',
                  child: Row(
                    children: [
                      Icon(Icons.archive),
                      SizedBox(width: 10),
                      Text('Arquivar'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'limpar',
                  child: Row(
                    children: [
                      Icon(Icons.clear),
                      SizedBox(width: 10),
                      Text('Limpar Conversa'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'remover',
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 10),
                      Text('Remover Contato'),
                    ],
                  ),
                ),
              ],
            )
          : */