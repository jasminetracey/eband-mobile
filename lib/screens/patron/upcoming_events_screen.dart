import 'package:eband/models/event.dart';
import 'package:eband/screens/components/custom_app_bar.dart';
import 'package:eband/screens/components/list_items_builder.dart';
import 'package:eband/screens/patron/components/event_card.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:eband/utils/app_text_styles.dart';
import 'package:eband/services/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpcomingEventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return Scaffold(
      appBar: CustomAppBar('Home'),
      body: SafeArea(
        minimum: kSafeArea,
        child: Column(
          children: <Widget>[
            Text(
              'Upcoming Events',
              style: AppTextStyles.headingTextPrimary,
            ),
            verticalSpaceSmall(context),
            Expanded(
              child: StreamBuilder<List<Event>>(
                stream: database.getEventsStream(),
                builder: (context, snapshot) {
                  return ListItemsBuilder<Event>(
                    snapshot: snapshot,
                    itemBuilder: (context, event) {
                      return EventCard(
                        event: event,
                        showImage: true,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
