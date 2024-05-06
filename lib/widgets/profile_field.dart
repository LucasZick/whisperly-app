import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/providers/user_data_provider.dart';
import 'package:whisperly/widgets/field_header.dart';
import 'package:whisperly/widgets/user_info_display.dart';
import 'package:whisperly/widgets/user_photo_display.dart';

class ProfileField extends StatelessWidget {
  const ProfileField({super.key, required this.onReturnPressed});
  final VoidCallback onReturnPressed;

  @override
  Widget build(BuildContext context) {
    UserDataProvider userDataProvider = Provider.of<UserDataProvider>(context);
    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Stack(
        children: [
          FieldHeader(
            title: "My profile",
            onReturnPressed: onReturnPressed,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UserPhotoDisplay(
                  photoUrl: userDataProvider.currentUser?.photoUrl,
                ),
                UserInfoDisplay(
                  user: userDataProvider.currentUser,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
