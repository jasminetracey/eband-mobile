import 'package:eband/models/user.dart';
import 'package:eband/router.dart';
import 'package:eband/screens/components/custom_app_bar.dart';
import 'package:eband/screens/components/rounded_button.dart';
import 'package:eband/utils/app_colors.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:eband/utils/app_images.dart';
import 'package:eband/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WristbandDetailsScreen extends StatelessWidget {
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
                Image.asset(
                  AppImages.wristband,
                  width: 128.0,
                ),
                verticalSpaceMedium(context),
                Container(
                  padding: const EdgeInsets.all(16),
                  width: screenWidth(context),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(kBorderRadius),
                  ),
                  child: Column(
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
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.bold),
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
                      RichText(
                        text: TextSpan(
                          text: 'Status: ',
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.bold),
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
                      RichText(
                        text: TextSpan(
                          text: 'Credit Amount: ',
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.bold),
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
                              text: 'Deactivate',
                              onPressed: () => {},
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceMedium(context),
                      Text(
                        'Active Events:',
                        style: AppTextStyles.headingTextPrimary,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            'Reggae Sumfest | 03.16.21',
                            style: AppTextStyles.bodyText,
                          )),
                          RoundedButton(
                            text: 'See Info',
                            onPressed: () {},
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
