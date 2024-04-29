import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/models/chat_model.dart';
import 'package:whisperly/providers/chats_provider.dart';

class ContactListTile extends StatelessWidget {
  const ContactListTile({super.key, required this.chat});
  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    ChatsProvider chatsProvider = Provider.of<ChatsProvider>(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(chat.contactUser.photoUrl ?? ""),
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        onSelected: (String value) {
          // Implemente a lógica para cada opção selecionada aqui
          switch (value) {
            case 'arquivar':
              // Lógica para arquivar a conversa
              break;
            case 'limpar':
              // Lógica para limpar a conversa
              break;
            case 'remover':
              // Lógica para remover o contato
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
      ),
      title: Text(
        chat.contactUser.displayName ?? "Contact",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: const Text(
        'Última mensagem enviada',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => chatsProvider.setCurrentChat(chat.chatId),
    );
  }
}
