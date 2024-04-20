import 'package:flutter/material.dart';
import 'package:whisperly/screens/identification_screen.dart';
import 'package:whisperly/wrapper.dart';

final routes = {
  '/': (BuildContext context) => const Wrapper(),
  '/identification': (BuildContext context) => const IdentificationScreen(),
};
