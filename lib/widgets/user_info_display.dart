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
  const UserInfoDisplay({super.key});

  @override
  State<UserInfoDisplay> createState() => _UserInfoDisplayState();
}

class _UserInfoDisplayState extends State<UserInfoDisplay> {
  final userInfoKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactCodeController = TextEditingController();

  bool isLoading = false;
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

  setLoading(bool newValue) {
    setState(() {
      isLoading = newValue;
    });
  }

  updateDisplayName(
      AuthService authService, UserDataProvider userDataProvider) async {
    setLoading(true);
    if (userInfoKey.currentState!.validate()) {
      await authService.changeDisplayName(nameController.text);
      await userDataProvider.updateUserName(nameController.text);
    }
    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    UserDataProvider userDataProvider =
        Provider.of<UserDataProvider>(context, listen: true);

    UserModel? user = userDataProvider.currentUser;
    Size screenSize = MediaQuery.of(context).size;

    if (nameController.text.isEmpty && user != null) {
      nameController.text = user.displayName ?? "";
    }
    if (contactCodeController.text.isEmpty && user != null) {
      contactCodeController.text = user.contactCode ?? "";
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
                decoration: InputDecoration(
                  label: const Text('Username'),
                  prefixIcon: const Icon(Icons.person),
                  suffixIcon: TextButton(
                    onPressed: isLoading
                        ? null
                        : () => updateDisplayName(
                              authService,
                              userDataProvider,
                            ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.5))
                        : const Icon(Icons.done),
                  ),
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
                    onPressed: () => copyToClipboard(user?.contactCode ?? ""),
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
