import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/screens/profile_screen.dart';
import 'package:whisperly/services/auth_service.dart';
import 'package:whisperly/utils/navigator_animations.dart';
import 'package:whisperly/widgets/button_switch_brightness.dart';
import 'package:whisperly/widgets/chat_central.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    User? user = FirebaseAuth.instance.currentUser;
    double frameWidth = MediaQuery.of(context).size.width * 0.8;
    double frameHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => NavigatorAnimations.transitionAnimation(
                context, const ProfileScreen()),
            icon: Hero(
              tag: "userProfilePic",
              child: CircleAvatar(
                backgroundImage: user != null && user.photoURL != null
                    ? NetworkImage(user.photoURL!)
                    : null,
                child: user == null || user.photoURL == null
                    ? const Icon(Icons.person)
                    : null,
              ),
            ),
          ),
          const ButtonSwitchBrightness(),
          IconButton(
            onPressed: authService.signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: frameWidth,
          height: frameHeight,
          child: const Center(child: ChatCentral()),
        ),
      ),
    );
  }
}
