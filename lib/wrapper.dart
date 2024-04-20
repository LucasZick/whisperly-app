import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/models/user_model.dart';
import 'package:whisperly/screens/opening_screen.dart';
import 'package:whisperly/services/auth_service.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return user == null
              ? const OpeningScreen()
              : Scaffold(
                  body: Center(
                    child: TextButton(
                      onPressed: authService.signOut,
                      child: const Text('sign out'),
                    ),
                  ),
                );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
