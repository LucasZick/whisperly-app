import 'package:flutter/material.dart';
import 'package:whisperly/widgets/user_info_display.dart';
import 'package:whisperly/widgets/user_photo_display.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double frameWidth = MediaQuery.of(context).size.width * 0.8;
    double frameHeight = MediaQuery.of(context).size.height * 0.8;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: frameWidth,
          height: frameHeight,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UserPhotoDisplay(),
              UserInfoDisplay(),
            ],
          ),
        ),
      ),
    );
  }
}
