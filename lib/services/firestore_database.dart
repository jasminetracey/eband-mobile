import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eband/models/event.dart';
import 'package:eband/models/ticket_type.dart';
import 'package:eband/models/user.dart';
import 'package:eband/models/wristband.dart';
import 'package:eband/services/firestore_path.dart';
import 'package:eband/services/firestore_service.dart';
import 'package:flutter/foundation.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid})
      : assert(uid != null, 'Cannot create FirestoreDatabase with null uid');

  final String uid;

  final _service = FirestoreService.instance;

  Future<void> createUser(User user) {
    return _service.setData(
      path: FirestorePath.user(user.uid),
      data: user.toJson(),
    );
  }

  // Reads the current user info
  Future getUser() async {
    final path = FirestorePath.user(uid);
    final snapshot = await Firestore.instance.document(path).get();
    return User.fromMap(snapshot.data, snapshot.documentID);
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

  Future<void> patronOrderWristband(Wristband wristband) async {
    await Firestore.instance
        .collection('users')
        .document(uid)
        .setData({'wristband': wristband.toJson()}, merge: true);
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
