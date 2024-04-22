import 'package:flutter/material.dart';
import 'package:whisperly/widgets/chat_field.dart';
import 'package:whisperly/widgets/contacts_field.dart';

class ChatCentral extends StatelessWidget {
  const ChatCentral({super.key});

  @override
  Widget build(BuildContext context) {
    double frameWidth = MediaQuery.of(context).size.width * 0.8;
    double frameHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: frameWidth,
      height: frameHeight,
      child: const Row(
        children: [
          ContactsField(),
          ChatField(),
        ],
      ),
    );
  }
}
