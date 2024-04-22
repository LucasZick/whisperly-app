import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/models/user_model.dart';
import 'package:whisperly/screens/main_screen.dart';
import 'package:whisperly/screens/opening_screen.dart';
import 'package:whisperly/services/auth_service.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<UserModel?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<UserModel?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final UserModel? user = snapshot.data;
          return user == null ? const OpeningScreen() : const MainScreen();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
