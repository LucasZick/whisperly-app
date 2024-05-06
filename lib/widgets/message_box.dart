import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whisperly/models/message_model.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({super.key, required this.message});
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    bool userSent = FirebaseAuth.instance.currentUser?.uid == message.senderId;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            userSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!userSent)
            CircleAvatar(
                backgroundImage: NetworkImage(message.sender?.photoUrl ?? "")),
          if (userSent) const Spacer(),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.only(
                      topRight:
                          userSent ? Radius.zero : const Radius.circular(12),
                      topLeft:
                          userSent ? const Radius.circular(12) : Radius.zero,
                      bottomRight: const Radius.circular(12),
                      bottomLeft: const Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.messageText ?? "",
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          DateFormat('kk:mm').format(message.timestamp),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (userSent)
            CircleAvatar(
                backgroundImage: NetworkImage(message.sender?.photoUrl ?? "")),
          if (!userSent) const Spacer(),
        ],
      ),
    );
  }
}
