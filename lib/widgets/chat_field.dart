import 'package:flutter/material.dart';
import 'package:whisperly/widgets/chat.dart';
import 'package:whisperly/widgets/chat_footer.dart';
import 'package:whisperly/widgets/chat_header.dart';

class ChatField extends StatelessWidget {
  const ChatField({super.key});

  @override
  Widget build(BuildContext context) {
    double frameWidth = MediaQuery.of(context).size.width;
    double frameHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: 7 / 10 * frameWidth,
      height: frameHeight,
      child: const SizedBox(
        child: Column(
          children: [
            ChatHeader(),
            Chat(),
            ChatFooter(),
          ],
        ),
      ),
    );
  }
}
