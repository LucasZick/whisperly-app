import 'package:flutter/material.dart';
import 'package:whisperly/widgets/field_header.dart';
import 'package:whisperly/widgets/user_info_display.dart';
import 'package:whisperly/widgets/user_photo_display.dart';

class ProfileField extends StatelessWidget {
  const ProfileField({super.key, required this.onReturnPressed});
  final VoidCallback onReturnPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Stack(
        children: [
          Positioned(
            child: FieldHeader(
              title: "Profile",
              onReturnPressed: onReturnPressed,
            ),
          ),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UserPhotoDisplay(),
                UserInfoDisplay(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
