import 'package:eband/models/event.dart';
import 'package:eband/models/ticket_type.dart';
import 'package:eband/router.dart';
import 'package:eband/screens/components/custom_app_bar.dart';
import 'package:eband/screens/patron/components/ticket_info.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:eband/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class RegisterEventScreen extends StatefulWidget {
  final Event event;

  const RegisterEventScreen({Key key, @required this.event}) : super(key: key);

  @override
  _RegisterEventScreenState createState() => _RegisterEventScreenState();
}

class _RegisterEventScreenState extends State<RegisterEventScreen> {
  Event event;

  @override
  void initState() {
    event = widget.event;
    super.initState();
  }

  int _radioValue;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Event Registration'),
      body: SafeArea(
        minimum: kSafeArea,
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            ClipRRect(
              borderRadius:
                  const BorderRadius.all(Radius.circular(kBorderRadius)),
              child: AspectRatio(
                aspectRatio: 2,
                child: Image.network(
                  event.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            verticalSpaceSmall(context),
            Text(
              event.name,
              style: AppTextStyles.headingTextPrimary,
            ),
            verticalSpaceSmall(context),
            Text(
              'Description:',
              style: AppTextStyles.subheadingText,
            ),
            Text(
              event.description,
              style: AppTextStyles.bodyText,
            ),
            verticalSpaceSmall(context),
            Text(
              'Venue:',
              style: AppTextStyles.subheadingText,
            ),
            Text(
              event.venue,
              style: AppTextStyles.bodyText,
            ),
            // TODO: Add google maps location
            verticalSpaceSmall(context),
            Text(
              'Date:',
              style: AppTextStyles.subheadingText,
            ),
            // TODO: Fix dates
            Text(
              'July 16, 2021',
              style: AppTextStyles.bodyText,
            ),
            verticalSpaceMedium(context),
            Text(
              'Select Preferred Ticket',
              style: AppTextStyles.headingTextPrimary,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: event.ticketTypes.map(
                (ticketType) {
                  return TicketInfo(
                    ticketType: TicketType(
                      id: ticketType.id,
                      name: ticketType.name,
                      cost: ticketType.cost,
                    ),
                    radioValue: _radioValue,
                    radioValueChange: _handleRadioValueChange,
                  );
                },
              ).toList(),
            ),
            verticalSpaceSmall(context),
            Container(
              alignment: Alignment.center,
              child: FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: const EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () => {
                  Navigator.pushNamed(
                    context,
                    Routes.patronEventPaymentRoute,
                    arguments: {
                      'ticketType': event.ticketTypes
                          .where((element) => element.id == _radioValue)
                          .first,
                      'event': event
                    },
                  )
                },
                child: const Text(
                  'Buy Ticket',
                ),
              ),
            ),
            verticalSpaceSmall(context),
          ],
        ),
      ),
    );
  }
}
