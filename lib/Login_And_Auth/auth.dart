import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);

  Future<String> createUserWithEmailAndPassword(String email, String password);

  Future<FirebaseUser> currentUser();

  Future<void> signOut();
}

class Auth implements BaseAuth {
  @override
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    // TODO: implement createUserWithEmailAndPassword
    FirebaseUser user = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password))
        .user;
    return user.email;
  }

  @override
  Future<FirebaseUser> currentUser() async {
    // TODO: implement currentUser
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
  }

  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    // TODO: implement signInWithEmailAndPassword
    FirebaseUser user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password))
        .user;
    return user.email;
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    return FirebaseAuth.instance.signOut();
  }
}
