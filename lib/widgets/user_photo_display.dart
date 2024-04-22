import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whisperly/utils/dynamic_size.dart';

class UserPhotoDisplay extends StatelessWidget {
  const UserPhotoDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    Size screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Hero(
          tag: "userProfilePic",
          child: CircleAvatar(
            radius: DynamicSize.getDynamicSmallerSizeWithMultiplier(
                screenSize, 0.1),
            backgroundImage: user != null && user.photoURL != null
                ? NetworkImage(user.photoURL!)
                : null,
            child: user == null || user.photoURL == null
                ? const Icon(Icons.person)
                : null,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: IconButton(
            color: Theme.of(context).colorScheme.primary,
            icon: Icon(
              Icons.change_circle,
              size: DynamicSize.getDynamicSmallerSizeWithMultiplier(
                  screenSize, 0.06),
            ),
            onPressed: () {},
          ),
        )
      ],
    );
  }
}
