import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisperly/models/user_model.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  UserModel? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(user.uid, user.email, user.displayName);
  }

  Stream<UserModel?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(credential.user);
  }

  Future<UserModel?> createUserWithEmailAndPassword(
    String email,
    String password,
    String username,
  ) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    registerUserDetails(credential, username);
    return _userFromFirebase(credential.user);
  }

  registerUserDetails(credential, username) {
    credential.user?.updateDisplayName(username);
    credential.user?.updatePhotoURL(
        "https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_640.png");
  }

  changeDisplayName(String newName) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateDisplayName(newName);
    }
  }

  changePhotoUrl(String newPhotoUrl) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.updatePhotoURL(newPhotoUrl);
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
