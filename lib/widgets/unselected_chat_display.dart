import 'package:flutter/material.dart';

class UnselectedChatDisplay extends StatelessWidget {
  const UnselectedChatDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat,
            size: 64.0,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20.0),
          const Text(
            "Welcome to Whisperly!",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          const Text(
            "Select any chat from the left menu to start whispering.",
            style: TextStyle(
              fontSize: 18.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
