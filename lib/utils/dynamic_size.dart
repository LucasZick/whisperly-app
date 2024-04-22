import 'package:flutter/material.dart';

class DynamicSize {
  static getDynamicSmallerSizeWithMultiplier(Size size, double multiplier) {
    return size.width < size.height
        ? size.width * multiplier
        : size.height * multiplier;
  }
}
