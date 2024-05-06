import 'package:flutter/material.dart';
import 'package:whisperly/utils/dynamic_size.dart';

class UserPhotoDisplay extends StatelessWidget {
  const UserPhotoDisplay({super.key, required this.photoUrl});
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Hero(
      tag: "userProfilePic",
      child: CircleAvatar(
        radius:
            DynamicSize.getDynamicSmallerSizeWithMultiplier(screenSize, 0.1),
        backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
      ),
    );
  }
}
