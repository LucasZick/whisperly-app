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

Future<List<UserModel>> getUsersFromIds(List memberIds) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<UserModel> users = [];

  for (String memberId in memberIds) {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await firestore.collection("users").doc(memberId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data()!;
        String uid = memberId;
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

        users.add(user);
      }
    } catch (e) {
      print('Erro ao buscar usuário com ID $memberId: $e');
    }
  }
  return users;
}
