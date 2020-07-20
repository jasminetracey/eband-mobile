import 'package:eband/models/event.dart';
import 'package:eband/models/user.dart';
import 'package:eband/router.dart';
import 'package:eband/screens/components/custom_app_bar.dart';
import 'package:eband/screens/components/rounded_button.dart';
import 'package:eband/screens/patron/components/event_card.dart';
import 'package:eband/services/firestore_database.dart';
import 'package:eband/utils/app_colors.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:eband/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WristbandDetailsScreen extends StatelessWidget {
  final GlobalKey globalKey = GlobalKey();
  final List<Event> items = Event.dummyList;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    return Scaffold(
      appBar: CustomAppBar('Wristband Details'),
      body: SafeArea(
        minimum: kSafeArea,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                verticalSpaceSmall(context),
                _buildGen(context, user.uid),
                verticalSpaceMedium(context),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Details:',
                      style: AppTextStyles.headingTextPrimary,
                    ),
                    verticalSpaceTiny(context),
                    RichText(
                      text: TextSpan(
                        text: 'User ID: ',
                        style: AppTextStyles.subheadingText.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: user.uid,
                            style: AppTextStyles.bodyTextPrimary.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpaceTiny(context),
                    RichText(
                      text: TextSpan(
                        text: 'Status: ',
                        style: AppTextStyles.subheadingText.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: user.wristband.activated
                                ? 'Activated'
                                : 'Not Activated',
                            style: AppTextStyles.bodyTextPrimary.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpaceTiny(context),
                    RichText(
                      text: TextSpan(
                        text: 'Credit Amount: ',
                        style: AppTextStyles.subheadingText.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${user.wristband.credits} Pts',
                            style: AppTextStyles.bodyTextPrimary.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpaceMedium(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: screenWidth(context) * 0.4,
                          child: RoundedButton(
                            text: 'Top Up',
                            onPressed: () => Navigator.pushNamed(
                                context, Routes.patronWristbandTopUp),
                          ),
                        ),
                        Container(
                          width: screenWidth(context) * 0.4,
                          child: RoundedButton(
                            text: user.wristband.activated
                                ? 'Deactivate'
                                : 'Activate',
                            onPressed: () async {
                              final FirestoreDatabase database =
                                  Provider.of<FirestoreDatabase>(context,
                                      listen: false);
                              await database.patronWristbandStatus(user);
                            },
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceMedium(context),
                    Text(
                      'Active Events:',
                      style: AppTextStyles.headingTextPrimary,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return EventCard(
                          event: items[index],
                          showImage: false,
                          alreadyBought: true,
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGen(BuildContext context, String uid) {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Center(
      child: Card(
        elevation: 2.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: Container(
          width: 225,
          height: 225,
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                width: 200,
                child: RepaintBoundary(
                  key: globalKey,
                  child: QrImage(
                    foregroundColor: AppColors.primaryColor,
                    data: uid,
                    size: 0.5 * bodyHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
