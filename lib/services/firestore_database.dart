import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eband/models/event.dart';
import 'package:eband/models/ticket_type.dart';
import 'package:eband/models/user.dart';
import 'package:eband/models/wristband.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid})
      : assert(uid != null, 'Cannot create FirestoreDatabase with null uid');

  final String uid;
  // final _service = FirestoreService.instance;

  // Stream<List<Event>> getUpcomingEvents() {
  //   final Stream<QuerySnapshot> snapshots =
  //       Firestore.instance.collection('events').where(field).snapshots();
  // }

  Stream<List<Event>> getPatronEvents() {
    final Stream<QuerySnapshot> snapshots = Firestore.instance
        .collection('users')
        .document(uid)
        .collection('events')
        .snapshots();

    return snapshots.map((snapshot) {
      final result = snapshot.documents
          .map((snapshot) =>
              Event.fromMap(snapshot.data['event'], snapshot.documentID))
          .where((value) => value != null)
          .toList();
      return result;
    });
  }

  Stream<List<Event>> getEventsStream() {
    final Stream<QuerySnapshot> snapshots =
        Firestore.instance.collection('events').snapshots();

    return snapshots.map((snapshot) {
      final result = snapshot.documents
          .map((snapshot) => Event.fromMap(snapshot.data, snapshot.documentID))
          .where((value) => value != null)
          .toList();
      return result;
    });
  }

  Future<void> patronRegisterPayment(TicketType ticketType, Event event) async {
    await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('events')
        .document()
        .setData({'ticketType': ticketType.toJson(), 'event': event.toJson()},
            merge: true);
  }

  Future<void> patronUpdateWristband(Wristband wristband) async {
    await Firestore.instance
        .collection('users')
        .document(uid)
        .setData({'wristband': wristband.toJson()}, merge: true);
  }

  Future<void> patronWristbandStatus(User user) async {
    await Firestore.instance.collection('users').document(user.uid).setData({
      'wristband': {
        'activated': !user.wristband.activated,
      }
    }, merge: true);
  }

  Stream<List<Event>> getOrganizerEvents() {
    final Stream<QuerySnapshot> snapshots = Firestore.instance
        .collection('events')
        .where('uid', isEqualTo: uid)
        .snapshots();

    return snapshots.map((snapshot) {
      final result = snapshot.documents
          .map((snapshot) => Event.fromMap(snapshot.data, snapshot.documentID))
          .where((value) => value != null)
          .toList();
      return result;
    });
  }

  Future<void> setEvent(Event event) async {
    final reference = Firestore.instance.document('events/${event.id}');
    await reference.setData(event.toJson(), merge: true);
  }
}
