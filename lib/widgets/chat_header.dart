import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const CircleAvatar(),
            const SizedBox(width: 10),
            Text(
              'Username',
              style: GoogleFonts.lato().copyWith(
                fontSize: 20,
                color: Theme.of(context).canvasColor,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
              color: Theme.of(context).canvasColor,
            )
          ],
        ),
      ),
    );
  }
}
