import 'package:flutter/material.dart';
import 'package:whisperly/screens/identification_screen.dart';
import 'package:whisperly/screens/main_screen.dart';
import 'package:whisperly/screens/profile_screen.dart';
import 'package:whisperly/wrapper.dart';

final routes = {
  '/': (BuildContext context) => const Wrapper(),
  '/identification': (BuildContext context) => const IdentificationScreen(),
  '/main': (BuildContext context) => const MainScreen(),
  '/profile': (BuildContext context) => const ProfileScreen(),
};
