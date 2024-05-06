import 'package:flutter/material.dart';
import 'package:whisperly/widgets/chat.dart';
import 'package:whisperly/widgets/chat_footer.dart';
import 'package:whisperly/widgets/chat_header.dart';

class ChatField extends StatelessWidget {
  const ChatField({super.key, required this.openProfile});
  final Function openProfile;

  @override
  Widget build(BuildContext context) {
    double frameWidth = MediaQuery.of(context).size.width;
    double frameHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: 7 / 10 * frameWidth,
      height: frameHeight,
      child: SizedBox(
        child: Column(
          children: [
            ChatHeader(openProfile: openProfile),
            const Chat(),
            ChatFooter(),
          ],
        ),
      ),
    );
  }
}
