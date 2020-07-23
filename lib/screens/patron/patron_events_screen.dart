import 'package:eband/models/event.dart';
import 'package:eband/screens/components/custom_app_bar.dart';
import 'package:eband/screens/components/list_items_builder.dart';
import 'package:eband/screens/patron/components/event_card.dart';
import 'package:eband/services/firestore_database.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:eband/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatronEventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);

    return Scaffold(
      appBar: CustomAppBar('My Events'),
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Active Events',
                style: AppTextStyles.headingTextPrimary,
              ),
              Container(
                height: 240,
                child: StreamBuilder<List<Event>>(
                  stream: database.getPatronEvents(),
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

                // ListView.builder(
                //   scrollDirection: Axis.horizontal,
                //   itemCount: events.length,
                //   itemBuilder: (context, index) {
                //     return EventCard(
                //       event: items[index],
                //       showImage: true,
                //       alreadyBought: true,
                //     );
                //   },
                // ),
              ),
              verticalSpaceMedium(context),
              Text(
                'Past Events',
                style: AppTextStyles.headingTextPrimary,
              ),
              // ListView.builder(
              //   physics: const NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   itemCount: events.length,
              //   itemBuilder: (context, index) {
              //     return EventCard(
              //       event: events[index],
              //       showImage: false,
              //       alreadyBought: true,
              //       past: true,
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
