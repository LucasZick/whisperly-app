import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  bool isLoading = false;

  setLoading(bool newValue) {
    setState(() {
      isLoading = newValue;
    });
  }

  updateDisplayName(AuthService authService) async {
    setLoading(true);
    if (userInfoKey.currentState!.validate()) {
      await authService.changeDisplayName(nameController.text);
    }
    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    User? user = FirebaseAuth.instance.currentUser;
    Size screenSize = MediaQuery.of(context).size;
    if (nameController.text.isEmpty && user != null) {
      nameController.text = user.displayName ?? "";
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
                    onPressed:
                        isLoading ? null : () => updateDisplayName(authService),
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
                initialValue: user?.email ?? "",
                textAlign: TextAlign.center,
                readOnly: true,
                decoration: const InputDecoration(
                  label: Text('Email'),
                  prefixIcon: Icon(Icons.email),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
