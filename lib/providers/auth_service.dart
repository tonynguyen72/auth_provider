import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user
  Future<FirebaseUser> getUser() {
    return _auth.currentUser();
  }

  //? logout
  Future logOut() {
    var result = _auth.signOut();
    notifyListeners();
    return result;
  }

  //?signup page --create user
  Future createUser({
    String firstName,
    String lastName,
    String email,
    String password,
  }) async {
    try {
      var u = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserUpdateInfo info = UserUpdateInfo();
      info.displayName = '$firstName $lastName';
      await u.user.updateProfile(info);
      notifyListeners();
      return u.user;
    } catch (e) {
      throw AuthException(e.code, e.message);
    }
  }

  //login user
  Future<FirebaseUser> loginUser({String email, String password}) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
      return result.user;
    } catch (e) {
      throw AuthException(e.code, e.message);
    }
  }

  //?
}
