import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whisperly/models/chat_model.dart';
import 'package:whisperly/models/message_model.dart';
import 'package:whisperly/models/user_model.dart';

class ChatsProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseDatabase = FirebaseFirestore.instance;

  List<ChatModel>? _chats;
  String? _currentChatId;

  List<ChatModel>? get chats => _chats;
  String? get currentChatId => _currentChatId;

  StreamSubscription<DocumentSnapshot>? _currentChatSubscription;
  final StreamController<ChatModel?> _currentChatController =
      StreamController<ChatModel?>.broadcast();
  Stream<ChatModel?> get currentChatStream => _currentChatController.stream;

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
          _chats = null;
          notifyListeners();
        }
      },
    );
  }

  setCurrentChat(String newChatId) async {
    _currentChatId = newChatId;
    _currentChatSubscription?.cancel();
    if (_currentChatId != null) {
      _currentChatSubscription = _firebaseDatabase
          .collection("chats")
          .doc(_currentChatId)
          .snapshots()
          .listen((chatSnapshot) async {
        if (chatSnapshot.exists) {
          ChatModel chat = await _getChatFromSnapshot(chatSnapshot);
          _currentChatController.add(chat);
        } else {
          _currentChatController.add(null);
        }
      });
    } else {
      _currentChatController.add(null);
    }
    notifyListeners();
  }

  Future<ChatModel> _getChatFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> chatSnapshot) async {
    List<UserModel> members =
        await getUsersFromIds(chatSnapshot.get("members") ?? []);
    List<dynamic> messagesData = chatSnapshot.get("messages") ?? [];

    // Converter os dados das mensagens em objetos MessageModel
    List<MessageModel> messages =
        messagesData.reversed.map<MessageModel>((messageData) {
      return MessageModel(
        messageId: messageData['messageId'],
        senderId: messageData['senderId'],
        messageText: messageData['messageText'],
        timestamp: messageData['timestamp'].toDate(),
        messageType: MessageType.values.firstWhere(
            (type) => type.toString() == messageData['messageType']),
        chatId: chatSnapshot.id,
      );
    }).toList();

    List<String> membersUid = List<String>.from(
      chatSnapshot.get("members") ?? [],
    );
    UserModel contactUser = UserModel();
    for (UserModel user in members) {
      if (user.uid != _firebaseAuth.currentUser?.uid) {
        contactUser = user;
      }
    }

    return ChatModel(
      chatId: chatSnapshot.id,
      membersUid: membersUid,
      members: members,
      messages: messages,
      contactUser: contactUser,
    );
  }

  Future<void> updateChats() async {
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
        List<dynamic> messagesData = chatSnapshot.get("messages") ?? [];

        // Converter os dados das mensagens em objetos MessageModel
        List<MessageModel> messages =
            messagesData.reversed.map<MessageModel>((messageData) {
          return MessageModel(
            messageId: messageData['messageId'],
            senderId: messageData['senderId'],
            messageText: messageData['messageText'],
            timestamp: messageData['timestamp'].toDate(),
            messageType: MessageType.values.firstWhere(
                (type) => type.toString() == messageData['messageType']),
            chatId: chatId,
          );
        }).toList();

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

      _chats = chats;
    } else {
      _chats = null;
    }
  }

  Future<void> sendMessage(String messageText, String chatId) async {
    try {
      // Crie uma nova mensagem
      MessageModel newMessage = MessageModel(
        messageId: UniqueKey().toString(),
        senderId: _firebaseAuth.currentUser!.uid,
        messageText: messageText,
        timestamp: DateTime.now(),
        messageType: MessageType.text,
        chatId: chatId,
      );

      _chats
          ?.firstWhere((chat) => chat.chatId == chatId)
          .messages
          .add(newMessage);

      // Adicione a mensagem ao Firestore
      await _firebaseDatabase.collection('chats').doc(chatId).update({
        'messages': FieldValue.arrayUnion([
          {
            'messageId': newMessage.messageId,
            'senderId': newMessage.senderId,
            'messageText': newMessage.messageText,
            'timestamp': newMessage.timestamp,
            'messageType': newMessage.messageType.toString(),
          }
        ])
      });
    } catch (error) {
      print('Erro ao enviar mensagem: $error');
    }
  }
}
