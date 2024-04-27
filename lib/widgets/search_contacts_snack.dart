import 'package:flutter/material.dart';

class SearchContactsSnack extends StatelessWidget {
  const SearchContactsSnack({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search a contact or group...",
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
