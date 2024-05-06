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
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _chatsSubscription;

  bool isChatLoading = false;

  ChatsProvider() {
    _firebaseAuth.authStateChanges().listen(
      (user) async {
        if (user != null) {
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
          _chatsSubscription = _firebaseDatabase
              .collection('chats')
              .where('members', arrayContains: user.uid)
              .snapshots()
              .listen((snapshot) async {
            await updateChats();
            notifyListeners();
          });
        } else {
          _chats = null;
          notifyListeners();
        }
      },
    );
  }

  setCurrentChat(String newChatId) async {
    if (newChatId == currentChatId) {
      return;
    }
    isChatLoading = true;
    notifyListeners();

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
        isChatLoading = false;
      });
    } else {
      _currentChatController.add(null);
      isChatLoading = false;
    }
    notifyListeners();
  }

  Future<ChatModel> _getChatFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> chatSnapshot) async {
    List<UserModel> members =
        await getUsersFromIds(chatSnapshot.get("members") ?? []);
    List<dynamic> messagesData = chatSnapshot.get("messages") ?? [];
    List<MessageModel> messages = await Future.wait(
      messagesData.reversed.map<Future<MessageModel>>((messageData) async {
        UserModel sender = await getUserFromId(messageData['senderId']);
        return MessageModel(
          messageId: messageData['messageId'],
          chatId: chatSnapshot.id,
          senderId: messageData['senderId'],
          sender: sender,
          messageText: messageData['messageText'],
          timestamp: messageData['timestamp'].toDate(),
          messageType: MessageType.values.firstWhere(
              (type) => type.toString() == messageData['messageType']),
        );
      }).toList(),
    );

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
      lastMessageTimestamp: chatSnapshot.get("lastMessageTimestamp").toDate(),
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
      List chatIds = userFromDatabase.get("chats") ?? [];
      for (String chatId in chatIds) {
        DocumentSnapshot<Map<String, dynamic>> chatSnapshot =
            await _firebaseDatabase.collection("chats").doc(chatId).get();

        List<UserModel> members =
            await getUsersFromIds(chatSnapshot.get("members") ?? []);

        Map<String, UserModel> membersMap = {};

        for (int i = 0; i < members.length; i++) {
          String? key = members[i].uid;
          membersMap[key!] = members[i];
        }

        List messagesData = chatSnapshot.get("messages") ?? [];

        DateTime? lastMessageTimestamp =
            chatSnapshot.get("lastMessageTimestamp")?.toDate();

        List<MessageModel> messages = messagesData.map<MessageModel>(
          (messageData) {
            UserModel? sender = membersMap[messageData['senderId']];
            return MessageModel(
              messageId: messageData['messageId'],
              chatId: chatSnapshot.id,
              senderId: messageData['senderId'],
              sender: sender,
              messageText: messageData['messageText'],
              timestamp: messageData['timestamp']?.toDate(),
              messageType: MessageType.values.firstWhere(
                  (type) => type.toString() == messageData['messageType']),
            );
          },
        ).toList();

        List<String> membersUid = membersMap.keys.toList();
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
            lastMessageTimestamp: lastMessageTimestamp,
          ),
        );
      }

      // Ordena a lista de chats com base no timestamp da última mensagem
      chats.sort((a, b) {
        if (a.lastMessageTimestamp == null && b.lastMessageTimestamp == null) {
          return 0; // Ambos são nulos, consideramos iguais
        } else if (a.lastMessageTimestamp == null) {
          return 1; // 'a' é nulo, 'b' é não-nulo, 'b' vem primeiro
        } else if (b.lastMessageTimestamp == null) {
          return -1; // 'b' é nulo, 'a' é não-nulo, 'a' vem primeiro
        } else {
          return b.lastMessageTimestamp!.compareTo(a.lastMessageTimestamp!);
        }
      });
      _chats = chats;
    } else {
      _chats = null;
    }
  }

  Future<void> sendMessage(String messageText, String chatId) async {
    try {
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

      await _firebaseDatabase.collection('chats').doc(chatId).update({
        'messages': FieldValue.arrayUnion([
          {
            'messageId': newMessage.messageId,
            'senderId': newMessage.senderId,
            'messageText': newMessage.messageText,
            'timestamp': newMessage.timestamp,
            'messageType': newMessage.messageType.toString(),
          },
        ]),
        'lastMessageTimestamp': newMessage.timestamp,
      });
    } catch (error) {
      print('Erro ao enviar mensagem: $error');
    }
  }
}
