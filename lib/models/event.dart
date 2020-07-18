import 'package:eband/models/ticket_type.dart';

class Event {
  final String uid;
  final String id;
  String imagePath;
  final String name;
  final DateTime start;
  final DateTime end;
  final String venue;
  final String address;
  String description;
  final String type;
  List<TicketType> ticketTypes;

// TODO: add required fields
  Event({
    this.uid,
    this.id,
    this.imagePath,
    this.name,
    this.venue,
    this.description,
    this.type,
    this.address,
    this.start,
    this.end,
    this.ticketTypes = const <TicketType>[],
  });

  factory Event.fromMap(Map<String, dynamic> data, String documentId) {
    final int startMilliseconds = data['start'];
    final int endMilliseconds = data['end'];

    List<TicketType> tickets = List<TicketType>.from(
      data['ticketTypes'].map(
        (dynamic item) {
          return TicketType(
            id: item['id'],
            name: item['name'],
            cost: item['cost'].toDouble(),
            quantity: item['quantity'],
            sold: item['sold'],
          );
        },
      ),
    );

    return Event(
      uid: data['uid'],
      id: documentId,
      name: data['name'] ?? '',
      imagePath: data['imagePath'] ?? '',
      venue: data['venue'] ?? '',
      address: data['address'] ?? '',
      type: data['type'] ?? '',
      description: data['description'] ?? '',
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
      ticketTypes: tickets,
    );
  }

  Map<String, dynamic> toJson() {
    final data = ticketTypes.map((it) => it.toJson()).toList();

    return {
      'uid': uid,
      'name': name,
      'imagePath': imagePath,
      'venue': venue,
      'address': address,
      'type': type,
      'description': description,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'ticketTypes': data,
    };
  }

  static List<Event> dummyList = <Event>[
    Event(
      imagePath:
          'https://images.unsplash.com/photo-1545852528-fa22f7fcd63e?ixlib=rb-1.2.1&auto=format&fit=crop&w=2102&q=80',
      name: 'Reggae SumFest',
    ),
    Event(
      imagePath:
          'https://images.unsplash.com/photo-1545852528-fa22f7fcd63e?ixlib=rb-1.2.1&auto=format&fit=crop&w=2102&q=80',
      name: 'Mawnin After',
    ),
    Event(
      imagePath:
          'https://images.unsplash.com/photo-1545852528-fa22f7fcd63e?ixlib=rb-1.2.1&auto=format&fit=crop&w=2102&q=80',
      name: 'Event 3',
    ),
    Event(
      imagePath:
          'https://images.unsplash.com/photo-1545852528-fa22f7fcd63e?ixlib=rb-1.2.1&auto=format&fit=crop&w=2102&q=80',
      name: 'Event 4',
    ),
    Event(
      imagePath:
          'https://images.unsplash.com/photo-1545852528-fa22f7fcd63e?ixlib=rb-1.2.1&auto=format&fit=crop&w=2102&q=80',
      name: 'Event 5',
    ),
  ];
}
