import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/models/user_model.dart';
import 'package:whisperly/providers/user_data_provider.dart';
import 'package:whisperly/services/auth_service.dart';
import 'package:whisperly/widgets/button_switch_brightness.dart';

class ContactsFieldHeader extends StatelessWidget {
  const ContactsFieldHeader(
      {super.key, required this.title, required this.openProfileField});
  final String title;
  final VoidCallback openProfileField;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    UserDataProvider userDataProvider =
        Provider.of<UserDataProvider>(context, listen: true);
    UserModel? user = userDataProvider.currentUser;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1000;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: !isSmallScreen,
            child: Text(
              title,
              style: GoogleFonts.lato().copyWith(
                fontSize: 25,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: openProfileField,
            child: Hero(
              tag: "userProfilePic",
              child: CircleAvatar(
                backgroundImage: user != null && user.photoUrl != null
                    ? NetworkImage(user.photoUrl ?? "")
                    : null,
                child: user == null || user.photoUrl == null
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
    );
  }
}
