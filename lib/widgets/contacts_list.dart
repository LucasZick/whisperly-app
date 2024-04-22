import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({super.key});

  final List<String> contacts = const [
    'Pedro',
    'João',
    'Guilherme',
    'Anderson',
    'Pedro',
    'João',
    'Guilherme',
    'Anderson',
    'Pedro',
    'João',
    'Guilherme',
    'Anderson',
    'Pedro',
    'João',
    'Guilherme',
    'Anderson',
    'Pedro',
    'João',
    'Guilherme',
    'Anderson',
    'Pedro',
    'João',
    'Guilherme',
    'Anderson',
    'Pedro',
    'João',
    'Guilherme',
    'Anderson',
    'Pedro',
    'João',
    'Guilherme',
    'Anderson',
    'Pedro',
    'João',
    'Guilherme',
    'Anderson',
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _buildContactTile(contacts[index]);
          },
        ),
      ),
    );
  }

  Widget _buildContactTile(String contactName) {
    return ListTile(
      leading: CircleAvatar(child: Text(contactName[0])),
      title: Text(contactName),
      subtitle: const Text('Última mensagem enviada'),
      trailing: const Icon(Icons.arrow_right),
      onTap: () {},
    );
  }
}
