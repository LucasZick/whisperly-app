import 'package:flutter/material.dart';
import 'package:whisperly/screens/identification_screen.dart';
import 'package:whisperly/widgets/button_switch_brightness.dart';
import 'package:whisperly/widgets/icon_opening_hoverable.dart';
import 'package:whisperly/widgets/opening_text_animation.dart';

class OpeningScreen extends StatelessWidget {
  const OpeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double frameWidth = MediaQuery.of(context).size.width * 0.8;
    double frameHeight = MediaQuery.of(context).size.height * 0.8;

    navigateToIdentificationScreen() {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const IdentificationScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: const [ButtonSwitchBrightness()],
      ),
      body: Center(
        child: SizedBox(
          width: frameWidth,
          height: frameHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const OpeningTextAnimation(),
              Hero(
                tag: "IconOpeningHoverable",
                child: IconOpeningHoverable(
                  size: frameHeight,
                  onPressed: navigateToIdentificationScreen,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
