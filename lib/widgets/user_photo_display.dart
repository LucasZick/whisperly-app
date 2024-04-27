import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/providers/user_data_provider.dart';
import 'package:whisperly/utils/dynamic_size.dart';

class UserPhotoDisplay extends StatelessWidget {
  const UserPhotoDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    UserDataProvider userDataProvider =
        Provider.of<UserDataProvider>(context, listen: true);
    Size screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Hero(
          tag: "userProfilePic",
          child: CircleAvatar(
            radius: DynamicSize.getDynamicSmallerSizeWithMultiplier(
                screenSize, 0.1),
            backgroundImage: userDataProvider.currentUser?.photoUrl != null &&
                    userDataProvider.currentUser?.photoUrl != null
                ? NetworkImage(userDataProvider.currentUser!.photoUrl!)
                : null,
            child: userDataProvider.currentUser == null ||
                    userDataProvider.currentUser?.photoUrl == null
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
