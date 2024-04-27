import 'package:flutter/material.dart';
import 'package:whisperly/widgets/contacts_field_header.dart';
import 'package:whisperly/widgets/contacts_list.dart';
import 'package:whisperly/widgets/search_contacts_snack.dart';

class ContactsField extends StatelessWidget {
  const ContactsField(
      {super.key,
      required this.openProfileField,
      required this.openAddFriendField});
  final VoidCallback openProfileField;
  final VoidCallback openAddFriendField;

  @override
  Widget build(BuildContext context) {
    double frameWidth = MediaQuery.of(context).size.width;
    double frameHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: 2 / 5 * frameWidth,
      height: frameHeight,
      child: Container(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Stack(
          children: [
            Column(
              children: [
                ContactsFieldHeader(
                  openProfileField: openProfileField,
                  title: 'Whisperly',
                ),
                const SearchContactsSnack(),
                const ContactsList(),
              ],
            ),
            Positioned(
              right: 25,
              bottom: 25,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.background,
                onPressed: openAddFriendField,
                child: const Icon(Icons.add),
              ),
            )
          ],
        ),
      ),
    );
  }
}
