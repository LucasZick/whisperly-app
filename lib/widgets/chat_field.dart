import 'package:flutter/material.dart';

class ChatField extends StatelessWidget {
  const ChatField({super.key});

  @override
  Widget build(BuildContext context) {
    double frameWidth = MediaQuery.of(context).size.width * 0.8;
    double frameHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: 3 / 5 * frameWidth,
      height: 19 / 20 * frameHeight,
      child: const Card(elevation: 15),
    );
  }
}
