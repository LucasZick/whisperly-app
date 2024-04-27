import 'package:flutter/material.dart';
import 'package:whisperly/widgets/chat_central.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ChatCentral(),
    );
  }
}
