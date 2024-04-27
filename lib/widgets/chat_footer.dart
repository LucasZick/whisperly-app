import 'package:flutter/material.dart';

class ChatFooter extends StatelessWidget {
  const ChatFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                maxLines: null, // Permite múltiplas linhas de texto
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.mic),
          ),
        ],
      ),
    );
  }
}
