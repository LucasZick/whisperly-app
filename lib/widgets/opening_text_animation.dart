import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OpeningTextAnimation extends StatelessWidget {
  const OpeningTextAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(width: 20.0, height: 100.0),
        const Text(
          'Whisperly is',
          style: TextStyle(fontSize: 40.0),
        ),
        const SizedBox(width: 20.0, height: 100.0),
        DefaultTextStyle(
          style: GoogleFonts.lato().copyWith(
            fontSize: 40.00,
            color: Theme.of(context).colorScheme.primary,
          ),
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              RotateAnimatedText('SAFE.'),
              RotateAnimatedText('PRIVATE.'),
              RotateAnimatedText('DIFFERENT.'),
              RotateAnimatedText('FAST.'),
              RotateAnimatedText('ACESSIBLE.'),
            ],
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
