import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/models/user_model.dart';
import 'package:whisperly/providers/user_data_provider.dart';
import 'package:whisperly/services/auth_service.dart';
import 'package:whisperly/utils/dynamic_size.dart';
import 'package:whisperly/utils/validators.dart';

class UserInfoDisplay extends StatefulWidget {
  const UserInfoDisplay({super.key, required this.user});
  final UserModel? user;

  @override
  State<UserInfoDisplay> createState() => _UserInfoDisplayState();
}

class _UserInfoDisplayState extends State<UserInfoDisplay> {
  final userInfoKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController photoUrlController = TextEditingController();
  final TextEditingController contactCodeController = TextEditingController();

  bool isUsernameLoading = false;
  bool isPhotoUrlLoading = false;
  IconData copyIcon = Icons.copy;
  bool showConfirmation = false;

  void copyToClipboard(String input) {
    Clipboard.setData(ClipboardData(text: input));
    setState(() {
      copyIcon = Icons.done;
      showConfirmation = true;
    });

    Timer(
      const Duration(seconds: 3),
      () {
        setState(() {
          copyIcon = Icons.copy;
          showConfirmation = false;
        });
      },
    );
  }

  setLoadingUsername(bool newValue) {
    setState(() {
      isUsernameLoading = newValue;
    });
  }

  setLoadingPhotoUrl(bool newValue) {
    setState(() {
      isPhotoUrlLoading = newValue;
    });
  }

  updateDisplayName(
      AuthService authService, UserDataProvider userDataProvider) async {
    setLoadingUsername(true);
    if (userInfoKey.currentState!.validate()) {
      await authService.changeDisplayName(nameController.text);
      await userDataProvider.updateUserName(nameController.text);
    }
    setLoadingUsername(false);
  }

  updatePhotoUrl(
      AuthService authService, UserDataProvider userDataProvider) async {
    setLoadingPhotoUrl(true);
    if (userInfoKey.currentState!.validate()) {
      await authService.changePhotoUrl(photoUrlController.text);
      await userDataProvider.updatePhotoUrl(photoUrlController.text);
    }
    setLoadingPhotoUrl(false);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    final authService = Provider.of<AuthService>(context);
    UserDataProvider userDataProvider =
        Provider.of<UserDataProvider>(context, listen: true);
    UserModel? authUser = userDataProvider.currentUser;
    bool isCurrentUser = authUser?.uid == widget.user?.displayName;

    if (nameController.text.isEmpty && widget.user != null) {
      nameController.text = widget.user?.displayName ?? "";
    }
    if (photoUrlController.text.isEmpty && widget.user != null) {
      photoUrlController.text = widget.user?.photoUrl ?? "";
    }
    if (contactCodeController.text.isEmpty && widget.user != null) {
      contactCodeController.text = widget.user?.contactCode ?? "";
    }

    return SizedBox(
      width: DynamicSize.getDynamicSmallerSizeWithMultiplier(screenSize, 0.5),
      child: Padding(
        padding: EdgeInsets.all(
            DynamicSize.getDynamicSmallerSizeWithMultiplier(screenSize, 0.05)),
        child: Form(
          key: userInfoKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                textAlign: TextAlign.center,
                validator: (input) => Validators.validateUsername(input),
                readOnly: !isCurrentUser,
                decoration: InputDecoration(
                  label: const Text('Username'),
                  prefixIcon: const Icon(Icons.person),
                  suffixIcon: widget.user?.uid == authUser?.uid
                      ? TextButton(
                          onPressed: isUsernameLoading
                              ? null
                              : () => updateDisplayName(
                                  authService, userDataProvider),
                          child: isUsernameLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5))
                              : const Icon(Icons.done),
                        )
                      : null,
                ),
              ),
              SizedBox(
                height: DynamicSize.getDynamicSmallerSizeWithMultiplier(
                    screenSize, 0.025),
              ),
              TextFormField(
                controller: photoUrlController,
                textAlign: TextAlign.center,
                validator: (input) => Validators.validatePhotoUrl(input),
                readOnly: !isCurrentUser,
                decoration: InputDecoration(
                  label: const Text('Photo URL'),
                  prefixIcon: const Icon(Icons.photo),
                  suffixIcon: widget.user?.uid == authUser?.uid
                      ? TextButton(
                          onPressed: isPhotoUrlLoading
                              ? null
                              : () =>
                                  updatePhotoUrl(authService, userDataProvider),
                          child: isPhotoUrlLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5))
                              : const Icon(Icons.done),
                        )
                      : null,
                ),
              ),
              SizedBox(
                height: DynamicSize.getDynamicSmallerSizeWithMultiplier(
                    screenSize, 0.025),
              ),
              TextFormField(
                controller: contactCodeController,
                textAlign: TextAlign.center,
                readOnly: true,
                decoration: InputDecoration(
                  label: const Text('Contact code'),
                  prefixIcon: const Icon(Icons.code),
                  suffixIcon: TextButton(
                    onPressed: () =>
                        copyToClipboard(widget.user?.contactCode ?? ""),
                    child: Icon(copyIcon),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
