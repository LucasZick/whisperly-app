import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? contactCode;
  final List? contacts;
  final List? chats;

  UserModel(
      {this.uid,
      this.email,
      this.displayName,
      this.photoUrl,
      this.contactCode,
      this.contacts,
      this.chats});
}

Future<UserModel> getUserFromId(String userId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await firestore.collection("users").doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data()!;
      String uid = userId;
      String displayName = userData['name'] ?? '';
      String email = userData['email'] ?? '';
      String photoUrl = userData['photo_url'] ?? '';
      String contactCode = userData['contact_code'] ?? '';

      UserModel user = UserModel(
        uid: uid,
        displayName: displayName,
        email: email,
        photoUrl: photoUrl,
        contactCode: contactCode,
      );

      return user;
    } else {
      return UserModel();
    }
  } catch (e) {
    print('Erro ao buscar usuário com ID $userId: $e');
    return UserModel();
  }
}

Future<List<UserModel>> getUsersFromIds(List memberIds) async {
  List<UserModel> users = [];

  for (String memberId in memberIds) {
    UserModel user = await getUserFromId(memberId);
    if (user.uid != null) {
      users.add(user);
    }
  }
  return users;
}
