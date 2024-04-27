import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/services/auth_service.dart';
import 'package:whisperly/widgets/button_switch_brightness.dart';

class FieldHeader extends StatelessWidget {
  const FieldHeader(
      {super.key, required this.title, required this.onReturnPressed});
  final VoidCallback onReturnPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    final userDataService = Provider.of<AuthService>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1000;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onReturnPressed,
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 10),
          Visibility(
            visible: !isSmallScreen, // Esconde o texto em telas pequenas
            child: Text(
              title,
              style: GoogleFonts.lato().copyWith(
                fontSize: 25,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const Spacer(),
          const ButtonSwitchBrightness(),
          IconButton(
            onPressed: userDataService.signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
