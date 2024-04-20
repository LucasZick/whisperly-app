import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/services/auth_service.dart';
import 'package:whisperly/utils/nickname_generator.dart';
import 'package:whisperly/widgets/button_change_id_mode.dart';
import 'package:whisperly/widgets/button_switch_brightness.dart';
import 'package:whisperly/widgets/icon_opening_hoverable.dart';
import 'package:whisperly/widgets/form_title.dart';
import 'package:whisperly/widgets/login_form.dart';
import 'package:whisperly/widgets/register_form.dart';

class IdentificationScreen extends StatefulWidget {
  const IdentificationScreen({super.key});

  @override
  State<IdentificationScreen> createState() => _IdentificationScreenState();
}

class _IdentificationScreenState extends State<IdentificationScreen> {
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final TextEditingController _usernameController =
      TextEditingController(text: NicknameGenerator.generateNickname());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  bool isLogin = true;

  toggleLoginMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  login(BuildContext context, AuthService authService) async {
    if (loginFormKey.currentState!.validate()) {
      await authService.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      Navigator.of(context).pop();
    }
  }

  register(BuildContext context, AuthService authService) async {
    if (registerFormKey.currentState!.validate()) {
      await authService.createUserWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);
    double frameWidth = MediaQuery.of(context).size.width * 0.8;
    double frameHeight = MediaQuery.of(context).size.height * 0.8;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: const [ButtonSwitchBrightness()],
      ),
      body: Center(
        child: SizedBox(
          width: frameWidth,
          height: frameHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hero(
                tag: "IconOpeningHoverable",
                child: IconOpeningHoverable(
                  size: frameHeight,
                  onPressed: () => isLogin
                      ? login(context, authService)
                      : register(context, authService),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: frameWidth * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FormTitle(label: isLogin ? "LOGIN" : "REGISTER"),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child: isLogin
                            ? LoginForm(
                                formKey: loginFormKey,
                                emailController: _emailController,
                                passwordController: _passwordController,
                              )
                            : RegisterForm(
                                formKey: registerFormKey,
                                usernameController: _usernameController,
                                emailController: _emailController,
                                passwordController: _passwordController,
                                passwordConfirmationController:
                                    _passwordConfirmationController,
                              ),
                      ),
                      ButtonChangeIdMode(
                        isLogin: isLogin,
                        onPressed: toggleLoginMode,
                      )
                    ],
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
