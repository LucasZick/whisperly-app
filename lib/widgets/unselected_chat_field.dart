import 'package:flutter/material.dart';
import 'package:whisperly/widgets/unselected_chat_display.dart';

class UnselectedChatField extends StatelessWidget {
  const UnselectedChatField({super.key});

  @override
  Widget build(BuildContext context) {
    Size frameSize = MediaQuery.of(context).size;
    return SizedBox(
      width: 7 / 10 * frameSize.width,
      height: frameSize.height,
      child: const SizedBox(
        child: Center(
          child: UnselectedChatDisplay(),
        ),
      ),
    );
  }
}
