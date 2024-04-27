import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whisperly/models/user_model.dart';

class UserDataProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseDatabase = FirebaseFirestore.instance;

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  List get chats => currentUser?.chats ?? [];

  List get contacts => currentUser?.chats ?? [];

  UserDataProvider() {
    _firebaseAuth.authStateChanges().listen(
      (user) {
        if (user != null) {
          updateUser();
          _firebaseDatabase
              .collection('users')
              .doc(user.uid)
              .snapshots()
              .listen(
            (snapshot) {
              if (snapshot.exists) {
                updateUser();
              }
            },
          );
        } else {
          _currentUser = null;
          notifyListeners();
        }
      },
    );
  }

  void updateUser() async {
    User? authenticatedUser = _firebaseAuth.currentUser;
    if (authenticatedUser != null) {
      DocumentSnapshot<Map<String, dynamic>> userFromDatabase =
          await _firebaseDatabase
              .collection("users")
              .doc(authenticatedUser.uid)
              .get();
      _currentUser = UserModel(
        uid: userFromDatabase.get("uid"),
        email: userFromDatabase.get("email"),
        displayName: userFromDatabase.get("name"),
        photoUrl: userFromDatabase.get("photo_url"),
        contactCode: userFromDatabase.get("contact_code"),
        contacts: userFromDatabase.get("contacts"),
        chats: userFromDatabase.get("chats"),
      );
    }
    notifyListeners();
  }

  updateUserName(String name) async {
    User? authenticatedUser = _firebaseAuth.currentUser;
    if (authenticatedUser != null) {
      await _firebaseDatabase
          .collection("users")
          .doc(authenticatedUser.uid)
          .update({'name': name});
    }
  }

  Future<String?> addContact(String contactCode) async {
    User? authenticatedUser = _firebaseAuth.currentUser;
    if (authenticatedUser != null) {
      String currentUserUid = authenticatedUser.uid;

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseDatabase
              .collection("users")
              .where("contact_code", isEqualTo: contactCode)
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            querySnapshot.docs.first;

        String contactUid = userSnapshot.id;
        if (contactUid != currentUserUid) {
          List<dynamic> contacts = userSnapshot.get("contacts") ?? [];
          if (contacts.contains(currentUserUid)) {
            return "Este usuário já está na sua lista de contatos.";
          }

          QuerySnapshot<Map<String, dynamic>> chatQuerySnapshot1 =
              await _firebaseDatabase
                  .collection("chats")
                  .where("members", arrayContains: currentUserUid)
                  .get();

          QuerySnapshot<Map<String, dynamic>> chatQuerySnapshot2 =
              await _firebaseDatabase
                  .collection("chats")
                  .where("members", arrayContains: contactUid)
                  .get();

          if (chatQuerySnapshot1.docs.isNotEmpty &&
              chatQuerySnapshot2.docs.isNotEmpty) {
            return "Já existe um chat entre vocês.";
          }

          String chatId = _firebaseDatabase.collection("chats").doc().id;

          Map<String, dynamic> chatData = {
            'chat_id': chatId,
            'members': [currentUserUid, contactUid],
            'messages': [],
          };

          await _firebaseDatabase.collection("chats").doc(chatId).set(chatData);

          await _firebaseDatabase
              .collection("users")
              .doc(currentUserUid)
              .update({
            'chats': FieldValue.arrayUnion([chatId]),
            'contacts': FieldValue.arrayUnion([contactUid])
          });

          await _firebaseDatabase.collection("users").doc(contactUid).update({
            'chats': FieldValue.arrayUnion([chatId]),
            'contacts': FieldValue.arrayUnion([currentUserUid])
          });

          return null;
        } else {
          return "Você não pode adicionar a si mesmo como um contato.";
        }
      } else {
        return "Nenhum usuário encontrado com o código de contato fornecido.";
      }
    } else {
      return "Usuário não autenticado.";
    }
  }
}
