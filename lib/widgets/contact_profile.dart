import 'package:flutter/material.dart';
import 'package:whisperly/models/user_model.dart';
import 'package:whisperly/widgets/field_header.dart';
import 'package:whisperly/widgets/user_info_display.dart';
import 'package:whisperly/widgets/user_photo_display.dart';

class ContactProfile extends StatelessWidget {
  const ContactProfile({
    super.key,
    required this.contact,
    required this.closeProfile,
  });
  final UserModel contact;
  final Function closeProfile;

  @override
  Widget build(BuildContext context) {
    double frameWidth = MediaQuery.of(context).size.width;
    double frameHeight = MediaQuery.of(context).size.height;
    return Container(
      width: 7 / 10 * frameWidth,
      height: frameHeight,
      color: Theme.of(context).canvasColor,
      child: Stack(
        children: [
          FieldHeader(
            title: "${contact.displayName}'s profile",
            onReturnPressed: () => closeProfile(null),
            showActionButtons: false,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UserPhotoDisplay(
                  photoUrl: contact.photoUrl,
                ),
                UserInfoDisplay(
                  user: contact,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
