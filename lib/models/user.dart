import 'package:flutter/foundation.dart';

enum UserType { patron, organizer, merchant }

class User {
  const User({
    @required this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.userType,
  }) : assert(uid != null, 'User can only be created with a non-null uid');

  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String userType;

  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    final String uid = documentId;
    if (uid == null) {
      return null;
    }

    final String email = data['email'];
    if (email == null) {
      return null;
    }

    final String firstName = data['firstName'];
    if (firstName == null) {
      return null;
    }

    final String lastName = data['lastName'];
    if (lastName == null) {
      return null;
    }

    final String userType = data['userType'];
    if (userType == null) {
      return null;
    }

    return User(
      uid: uid,
      email: email,
      firstName: firstName,
      lastName: lastName,
      userType: userType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'userType': userType,
    };
  }

  @override
  String toString() => 'uid: $uid, email: $email, firstName: $firstName, '
      'lastName: $lastName, userType: $userType';
}
