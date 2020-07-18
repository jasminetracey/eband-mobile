import 'package:eband/router.dart';
import 'package:eband/screens/components/custom_app_bar.dart';
import 'package:eband/screens/components/rounded_button.dart';
import 'package:eband/screens/patron/components/payment_method.dart';
import 'package:eband/utils/app_colors.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:eband/utils/app_images.dart';
import 'package:eband/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WristbandTopUpScreen extends StatefulWidget {
  @override
  _WristbandTopUpScreenState createState() => _WristbandTopUpScreenState();
}

class _WristbandTopUpScreenState extends State<WristbandTopUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedCredit;

  List<DropdownMenuItem<int>> creditAmounts = [];

  void loadCreditList() {
    creditAmounts.add(const DropdownMenuItem(
      child: Text(
        '5000',
        style: TextStyle(color: AppColors.whiteColor),
      ),
      value: 5000,
    ));
    creditAmounts.add(const DropdownMenuItem(
      child: Text(
        '10000',
        style: TextStyle(color: AppColors.whiteColor),
      ),
      value: 1000,
    ));
    creditAmounts.add(const DropdownMenuItem(
      child: Text(
        '15000',
        style: TextStyle(color: AppColors.whiteColor),
      ),
      value: 15000,
    ));
  }

  @override
  void initState() {
    loadCreditList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar('Wristband Top Up'),
      body: SafeArea(
        minimum: kSafeArea,
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  verticalSpaceSmall(context),
                  Center(
                    child: Image.asset(
                      AppImages.wristband,
                      width: 128.0,
                    ),
                  ),
                  verticalSpaceSmall(context),
                  Text(
                    'Details',
                    style: AppTextStyles.subheadingText,
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
                          text: 'WT2435UBDF',
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
                      style: TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Activated',
                          style: AppTextStyles.bodyTextPrimary.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceSmall(context),
                  Text(
                    'Credit Amounts',
                    style: AppTextStyles.subheadingText,
                  ),
                  verticalSpaceTiny(context),
                  FractionallySizedBox(
                    widthFactor: 0.7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(kBorderRadius),
                      ),
                      child: DropdownButton(
                        hint: const Text(
                          'Select Credit Amount',
                          style: TextStyle(color: AppColors.whiteColor),
                        ),
                        dropdownColor: AppColors.primaryColor,
                        isExpanded: true,
                        value: _selectedCredit,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.whiteColor,
                        ),
                        underline: const SizedBox(),
                        items: creditAmounts,
                        onChanged: (dynamic newValue) {
                          setState(() {
                            _selectedCredit = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  verticalSpaceTiny(context),
                  Text(
                    'Credit Value: 1 Pt = \$1.25',
                    style: AppTextStyles.bodyText.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  verticalSpaceSmall(context),
                  Text(
                    'Payment Method',
                    style: AppTextStyles.subheadingText,
                  ),
                  PaymentMethodDetails(),
                  verticalSpaceMedium(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: screenWidth(context) * 0.4,
                        child: RoundedButton(
                          text: 'Top Up',
                          onPressed: () => topUp(),
                        ),
                      ),
                      Container(
                        width: screenWidth(context) * 0.4,
                        child: RoundedButton(
                          color: AppColors.iconColor,
                          textColor: AppColors.textColor,
                          text: 'Cancel',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void topUp() {
    Navigator.pushReplacementNamed(
      context,
      Routes.patronWristbandDetails,
    );

    if (_formKey.currentState.validate()) {
      if (_selectedCredit == null) {
        _showSnackBar('Please Select Credit Amount');
      } else {
        Navigator.pushReplacementNamed(
          context,
          Routes.patronWristbandDetails,
        );
      }
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      backgroundColor: AppColors.primaryColor,
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
