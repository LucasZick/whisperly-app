import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/models/chat_model.dart';
import 'package:whisperly/providers/chats_provider.dart';
import 'package:whisperly/widgets/contact_list_tile.dart';
import 'package:whisperly/widgets/no_items_warning.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context) {
    ChatsProvider chatsProvider =
        Provider.of<ChatsProvider>(context, listen: true);
    List<ChatModel>? chats = chatsProvider.currentChats;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Material(
          type: MaterialType.transparency,
          child: chats != null && chats.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    return ContactListTile(chat: chats[index]);
                  },
                )
              : const NoItemsWarning(itemType: "contacts"),
        ),
      ),
    );
  }
}
