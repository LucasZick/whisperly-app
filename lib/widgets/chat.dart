import 'package:flutter/material.dart';
import 'package:whisperly/widgets/message_box.dart';
import 'package:whisperly/widgets/no_items_warning.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [];
    return Expanded(
      child: Container(
        child: messages.isNotEmpty
            ? ListView.builder(
                itemCount: messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  return MessageBox(
                      message: messages[index]['message'] as String,
                      userSent: messages[index]['sender'] == 0);
                },
              )
            : const Center(
                child: NoItemsWarning(
                itemType: "messages",
              )),
      ),
    );
  }
}
