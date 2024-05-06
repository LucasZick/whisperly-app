import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/models/user_model.dart';
import 'package:whisperly/providers/chats_provider.dart';
import 'package:whisperly/widgets/add_contact_field.dart';
import 'package:whisperly/widgets/chat_field.dart';
import 'package:whisperly/widgets/contact_profile.dart';
import 'package:whisperly/widgets/contacts_field.dart';
import 'package:whisperly/widgets/profile_field.dart';
import 'package:whisperly/widgets/unselected_chat_field.dart';

enum FieldMode { contactsList, profile, addContact }

class ChatCentral extends StatefulWidget {
  const ChatCentral({super.key});

  @override
  ChatCentralState createState() => ChatCentralState();
}

class ChatCentralState extends State<ChatCentral> {
  FieldMode currentMode = FieldMode.contactsList;
  UserModel? contactProfileOpened;

  setMode(FieldMode newMode) {
    setState(() {
      currentMode = newMode;
    });
  }

  void updateContactProfile(UserModel? contact) {
    setState(() {
      contactProfileOpened = contact;
    });
  }

  @override
  Widget build(BuildContext context) {
    ChatsProvider chatsProvider = Provider.of<ChatsProvider>(context);

    Map<FieldMode, Widget> fields = {
      FieldMode.contactsList: ContactsField(
        openProfileField: () => setMode(FieldMode.profile),
        openAddFriendField: () => setMode(FieldMode.addContact),
      ),
      FieldMode.profile: ProfileField(
        onReturnPressed: () => setMode(FieldMode.contactsList),
      ),
      FieldMode.addContact: AddContactField(
        onReturnPressed: () => setMode(FieldMode.contactsList),
      ),
    };

    Widget currentField = fields[currentMode]!;

    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: Tween(
                            begin: const Offset(-2.0, 0.0),
                            end: const Offset(0.0, 0.0))
                        .animate(animation),
                    child: child,
                  );
                },
                child: currentField,
              ),
            ],
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween(
                      begin: const Offset(0.0, -2.0),
                      end: const Offset(0.0, 0.0))
                  .animate(animation),
              child: child,
            );
          },
          child: chatsProvider.currentChatId != null
              ? Stack(
                  children: [
                    ChatField(openProfile: updateContactProfile),
                    AnimatedOpacity(
                      opacity: contactProfileOpened != null ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: contactProfileOpened != null
                          ? ContactProfile(
                              contact: contactProfileOpened!,
                              closeProfile: updateContactProfile,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                )
              : const UnselectedChatField(),
        ),
      ],
    );
  }
}
