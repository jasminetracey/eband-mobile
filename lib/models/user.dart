import 'package:eband/models/wristband.dart';
import 'package:flutter/foundation.dart';

enum UserType { patron, organizer, merchant }

class User {
  User({
    @required this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.userType,
    this.wristband,
  }) : assert(uid != null, 'User can only be created with a non-null uid');

  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String userType;
  Wristband wristband;

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

    final dynamic wristband = data['wristband'];

    return User(
      uid: uid,
      email: email,
      firstName: firstName,
      lastName: lastName,
      userType: userType,
      wristband: wristband != null
          ? Wristband(
              activated: wristband['activated'],
              credits: wristband['credits'],
              address: wristband['address'] ?? '',
              phoneNumber: wristband['phoneNumber'] ?? '',
            )
          : null,
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
