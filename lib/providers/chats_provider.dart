import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whisperly/models/chat_model.dart';
import 'package:whisperly/models/message_model.dart';
import 'package:whisperly/models/user_model.dart';

class ChatsProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseDatabase = FirebaseFirestore.instance;

  List<ChatModel>? _currentChats;

  List<ChatModel>? get currentChats => _currentChats;

  ChatsProvider() {
    _firebaseAuth.authStateChanges().listen(
      (user) async {
        if (user != null) {
          await updateChats();
          notifyListeners();

          _firebaseDatabase
              .collection('users')
              .doc(user.uid)
              .snapshots()
              .listen(
            (snapshots) async {
              if (snapshots.exists) {
                await updateChats();
                notifyListeners();
              }
            },
          );
        } else {
          _currentChats = null;
          notifyListeners();
        }
      },
    );
  }

  updateChats() async {
    User? authenticatedUser = _firebaseAuth.currentUser;
    if (authenticatedUser != null) {
      DocumentSnapshot<Map<String, dynamic>> userFromDatabase =
          await _firebaseDatabase
              .collection("users")
              .doc(authenticatedUser.uid)
              .get();

      List<ChatModel> chats = [];
      List<dynamic> chatIds = userFromDatabase.get("chats") ?? [];
      for (String chatId in chatIds) {
        DocumentSnapshot<Map<String, dynamic>> chatSnapshot =
            await _firebaseDatabase.collection("chats").doc(chatId).get();
        List<UserModel> members =
            await getUsersFromIds(chatSnapshot.get("members") ?? []);
        List<MessageModel> messages = chatSnapshot.get("messages") ?? [];
        List<String> membersUid = List<String>.from(
          chatSnapshot.get("members") ?? [],
        );
        UserModel contactUser = UserModel();
        for (UserModel user in members) {
          if (user.uid != _firebaseAuth.currentUser?.uid) {
            contactUser = user;
          }
        }

        chats.add(
          ChatModel(
            chatId: chatId,
            membersUid: membersUid,
            members: members,
            messages: messages,
            contactUser: contactUser,
          ),
        );
      }

      _currentChats = chats;
    } else {
      _currentChats = null;
    }
  }
}
