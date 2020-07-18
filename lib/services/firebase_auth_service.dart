import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eband/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  // Firebase user one-time fetch
  Future<FirebaseUser> get getUser => _firebaseAuth.currentUser();

  // Firebase user a realtime stream
  Stream<FirebaseUser> get user => _firebaseAuth.onAuthStateChanged;

  //Streams the firestore user from the firestore collection
  Stream<User> streamFirestoreUser(FirebaseUser firebaseUser) {
    if (firebaseUser?.uid != null) {
      return _db
          .document('/users/${firebaseUser.uid}')
          .snapshots()
          .map((snapshot) => User.fromMap(snapshot.data, firebaseUser.uid));
    }
    return null;
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));

    return true;
  }

  Future<bool> createUserWithEmailAndPassword(String email, String password,
      String firstName, String lastName, UserType userType) async {
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((result) async {
      final User _user = User(
          uid: result.user.uid,
          email: email,
          firstName: firstName,
          lastName: lastName,
          userType: userType.toString());

      _updateUserFirestore(_user, result.user);
    });

    return true;
  }

  //updates the firestore users collection
  void _updateUserFirestore(User user, FirebaseUser firebaseUser) {
    _db
        .document('/users/${firebaseUser.uid}')
        .setData(user.toJson(), merge: true);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
