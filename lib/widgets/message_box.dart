import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({super.key, required this.message, required this.userSent});
  final String message;
  final bool userSent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            userSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!userSent) const CircleAvatar(),
          if (userSent) const Spacer(),
          Flexible(
            // Utilizando Flexible ao invés de Expanded
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.only(
                    topRight:
                        userSent ? Radius.zero : const Radius.circular(12),
                    topLeft: userSent ? const Radius.circular(12) : Radius.zero,
                    bottomRight: const Radius.circular(12),
                    bottomLeft: const Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    message,
                  ),
                ),
              ),
            ),
          ),
          if (userSent) const CircleAvatar(),
          if (!userSent) const Spacer(),
        ],
      ),
    );
  }
}
