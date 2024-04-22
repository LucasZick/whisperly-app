import 'package:flutter/material.dart';
import 'package:whisperly/widgets/contacts_list.dart';
import 'package:whisperly/widgets/search_contacts_snack.dart';

class ContactsField extends StatelessWidget {
  const ContactsField({super.key});

  @override
  Widget build(BuildContext context) {
    double frameWidth = MediaQuery.of(context).size.width * 0.8;
    double frameHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: 2 / 5 * frameWidth,
      height: 19 / 20 * frameHeight,
      child: Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        elevation: 15,
        child: const Column(
          children: [
            SearchContactsSnack(),
            ContactsList(),
          ],
        ),
      ),
    );
  }
}
