import 'package:flutter/material.dart';

class NoItemsWarning extends StatelessWidget {
  const NoItemsWarning({super.key, required this.itemType});
  final String itemType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'NO ${itemType.toUpperCase()} YET',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Text(
          'It seems that you have no $itemType',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
