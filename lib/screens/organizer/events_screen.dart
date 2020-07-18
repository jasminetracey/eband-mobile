import 'package:eband/models/event.dart';
import 'package:eband/router.dart';
import 'package:eband/screens/components/custom_app_bar.dart';
import 'package:eband/screens/components/list_items_builder.dart';
import 'package:eband/services/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizerEventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);

    return Scaffold(
      appBar: CustomAppBar('My Events'),
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: StreamBuilder<List<Event>>(
          stream: database.getOrganizerEvents(),
          builder: (context, snapshot) {
            return ListItemsBuilder<Event>(
              snapshot: snapshot,
              itemBuilder: (context, event) {
                return _listItem(event, context);
              },
            );
          },
        ),
      ),
    );
  }
}

Widget _listItem(Event event, BuildContext context) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  event.name,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Manage',
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(
              context,
              Routes.organizerEventManagementRoute,
              arguments: event,
            ),
          ),
          IconButton(
            tooltip: 'Edit',
            icon: Icon(Icons.edit),
            onPressed: () => {},
          ),
          IconButton(
            tooltip: 'Delete',
            icon: Icon(Icons.delete),
            onPressed: () => {},
          )
        ],
      ),
    ),
  );
}
