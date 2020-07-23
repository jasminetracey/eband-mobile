import 'package:eband/models/event.dart';
import 'package:eband/models/user.dart';
import 'package:eband/router.dart';
import 'package:eband/screens/components/rounded_button.dart';
import 'package:eband/utils/app_colors.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:eband/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final bool showImage;

  const EventCard({
    Key key,
    this.event,
    this.showImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final alreadyBought = event.boughtTicket.contains(user.uid);
    final past = DateTime.now().isAfter(event.end);

    return Container(
      width: screenWidth(context) * 0.8,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            offset: const Offset(0, 3),
            color: Colors.grey[300],
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      margin: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (showImage) ...[
            ClipRRect(
              child: AspectRatio(
                aspectRatio: 2.5,
                child: Image.network(
                  event.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              borderRadius: BorderRadius.circular(kBorderRadius),
            )
          ],
          verticalSpaceSmall(context),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      event.name,
                      textAlign: TextAlign.left,
                      style: AppTextStyles.subheadingText,
                    ),
                    Text(
                      '03.16.21',
                      style: AppTextStyles.bodyText,
                    ),
                  ],
                ),
                if (!alreadyBought && !past)
                  RoundedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      Routes.patronEventRegisterRoute,
                      arguments: event,
                    ),
                    text: 'Buy Ticket',
                  ),
                if (alreadyBought && !past)
                  RoundedButton(
                    onPressed: () => {},
                    text: 'See Ticket',
                  ),
                if (alreadyBought && past)
                  RoundedButton(
                    onPressed: () {},
                    text: 'See Info',
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
