import 'package:flutter/material.dart';

class SearchContactsSnack extends StatelessWidget {
  const SearchContactsSnack({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search a contact or group...",
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
