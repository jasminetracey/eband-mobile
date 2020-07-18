import 'package:eband/formatters/card_month_input_formatter.dart';
import 'package:eband/formatters/card_number_input_formatter.dart';
import 'package:eband/models/payment_card.dart';
import 'package:eband/models/wristband.dart';
import 'package:eband/router.dart';
import 'package:eband/screens/components/custom_app_bar.dart';
import 'package:eband/screens/components/custom_dialog.dart';
import 'package:eband/screens/components/rounded_button.dart';
import 'package:eband/screens/patron/components/payment_method.dart';
import 'package:eband/services/firestore_database.dart';
import 'package:eband/utils/app_colors.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:eband/utils/app_images.dart';
import 'package:eband/utils/app_strings.dart';
import 'package:eband/utils/app_text_styles.dart';
import 'package:eband/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class WristbandOrderScreen extends StatefulWidget {
  @override
  _WristbandOrderScreenState createState() => _WristbandOrderScreenState();
}

class _WristbandOrderScreenState extends State<WristbandOrderScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  TextEditingController numberController = TextEditingController();
  final PaymentCard _paymentCard = PaymentCard();
  List<Widget> cardWidgets = <Widget>[];
  String _pin, _pinConfirm, _address, _phone;
  bool _termsAndConditionsChecked = false;

  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    // TODO: Remove in prod
    numberController.text = '5555 5555 5555 4444';
    _filterCards();
    numberController.addListener(_getCardTypeFrmNumber);
    super.initState();
  }

  @override
  void dispose() {
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    pinController.dispose();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    final String input = CardUtils.getCleanedNumber(numberController.text);
    final CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      _paymentCard.type = cardType;
    });
    _filterCards();
  }

  void _filterCards() {
    cardWidgets.clear();

    if ((_paymentCard.type == null && _paymentCard.number == null) ||
        (_paymentCard.type == CardType.invalid &&
            numberController.text.isEmpty)) {
      for (final CardType type in CardType.values) {
        if (type != CardType.invalid) {
          cardWidgets.add(CardUtils.getCardIcon(type));
        }
      }
    } else {
      cardWidgets.add(CardUtils.getCardIcon(_paymentCard.type));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar('Wristband Order'),
      body: SafeArea(
        minimum: kSafeArea,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset(
                      AppImages.wristband,
                      width: 80.0,
                    ),
                    SizedBox(
                      width: screenWidth(context) * 0.05,
                    ),
                    Text(
                      'Wristband Order',
                      style: AppTextStyles.headingTextPrimary,
                    ),
                  ],
                ),
                verticalSpaceTiny(context),
                Text(
                  'Please complete the following in order to place wristband order to access events',
                  style: AppTextStyles.bodyText,
                ),
                verticalSpaceSmall(context),
                Text(
                  'Wristband Payment - \$ 1500.00 JMD',
                  style: AppTextStyles.subheadingText,
                ),
                verticalSpaceMedium(context),
                // Text(
                //   'Wristband Pin:',
                //   style: AppTextStyles.subheadingText,
                // ),
                // verticalSpaceTiny(context),
                // TextFormField(
                //   obscureText: true,
                //   inputFormatters: [
                //     WhitelistingTextInputFormatter.digitsOnly,
                //     LengthLimitingTextInputFormatter(4),
                //   ],
                //   onSaved: (value) => _pin = value,
                //   keyboardType: TextInputType.number,
                //   validator: Validators.validatePin,
                //   controller: pinController,
                //   decoration: InputDecoration(
                //     filled: true,
                //     suffixIcon: Icon(
                //       Icons.lock_outline,
                //       color: AppColors.primaryColor,
                //     ),
                //     hintText: 'Create Unique Pin',
                //   ),
                // ),
                // verticalSpaceTiny(context),
                // TextFormField(
                //   obscureText: true,
                //   inputFormatters: [
                //     WhitelistingTextInputFormatter.digitsOnly,
                //     LengthLimitingTextInputFormatter(4),
                //   ],
                //   onSaved: (value) => _pinConfirm = value,
                //   keyboardType: TextInputType.number,
                //   validator: (value) =>
                //       Validators.validateConfirmPin(value, pinController.text),
                //   decoration: InputDecoration(
                //     suffixIcon: Icon(
                //       Icons.lock_outline,
                //       color: AppColors.primaryColor,
                //     ),
                //     hintText: 'Confirm Unique Pin',
                //   ),
                // ),
                // verticalSpaceSmall(context),
                Text(
                  'Address:',
                  style: AppTextStyles.subheadingText,
                ),
                TextFormField(
                  onSaved: (value) => _address = value,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    return value.isEmpty ? 'Address is required' : null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter full address',
                  ),
                ),
                verticalSpaceSmall(context),
                Text(
                  'Contact Number:',
                  style: AppTextStyles.subheadingText,
                ),
                TextFormField(
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onSaved: (value) => _phone = value,
                  keyboardType: TextInputType.number,
                  validator: Validators.validatePhoneNumber,
                  decoration: const InputDecoration(
                    hintText: 'Enter your contact number',
                  ),
                ),
                verticalSpaceSmall(context),
                Text(
                  'Payment Method',
                  style: AppTextStyles.subheadingText,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: cardWidgets,
                ),
                verticalSpaceSmall(context),
                TextFormField(
                  onSaved: (value) => _paymentCard.name = value,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    return value.isEmpty ? 'Card Name is required' : null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Name on Card',
                  ),
                ),
                verticalSpaceSmall(context),
                TextFormField(
                  onSaved: (value) =>
                      _paymentCard.number = CardUtils.getCleanedNumber(value),
                  keyboardType: TextInputType.number,
                  controller: numberController,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(19),
                    CardNumberInputFormatter()
                  ],
                  validator: Validators.validateCardNum,
                  decoration: const InputDecoration(
                    hintText: 'Card Number',
                  ),
                ),
                verticalSpaceSmall(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: screenWidth(context) * 0.5,
                      child: TextFormField(
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                          CardMonthInputFormatter()
                        ],
                        onSaved: (value) {
                          final List<int> expiryDate =
                              CardUtils.getExpiryDate(value);
                          _paymentCard.month = expiryDate[0];
                          _paymentCard.year = expiryDate[1];
                        },
                        keyboardType: TextInputType.number,
                        validator: Validators.validateDate,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: 'MM/YY',
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth(context) * 0.4,
                      child: TextFormField(
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        onSaved: (value) => _paymentCard.cvv = int.parse(value),
                        keyboardType: TextInputType.number,
                        validator: Validators.validateCVV,
                        decoration: const InputDecoration(
                          hintText: 'CVV Code',
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpaceMedium(context),
                CheckboxListTile(
                  title: Text(
                    AppStrings.policyText,
                    style: AppTextStyles.bodyTextPrimary,
                  ),
                  value: _termsAndConditionsChecked,
                  onChanged: (value) =>
                      setState(() => _termsAndConditionsChecked = value),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                verticalSpaceMedium(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: screenWidth(context) * 0.4,
                      child: RoundedButton(
                        text: 'Order',
                        onPressed: () => orderWristband(context),
                      ),
                    ),
                    if (Navigator.canPop(context))
                      Container(
                        width: screenWidth(context) * 0.4,
                        child: RoundedButton(
                          color: AppColors.iconColor,
                          textColor: AppColors.textColor,
                          text: 'Cancel',
                          onPressed: () {
                            Navigator.popUntil(
                              context,
                              ModalRoute.withName(Routes.patronTabRoute),
                            );
                          },
                        ),
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

  Future<void> orderWristband(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      if (!_termsAndConditionsChecked) {
        // The checkbox wasn't checked
        _showSnackBar('Please accept our terms and conditions');
      } else {
        _formKey.currentState.save();

        final database = Provider.of<FirestoreDatabase>(context, listen: false);
        await database.patronOrderWristband(
          Wristband(address: _address, phoneNumber: _phone),
        );

        _showDialog(context);
      }
    } else {
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });
    }
  }

  void _showDialog(BuildContext context) {
    showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomDialog(
        title: 'Order Successful',
        leftText: 'Ok',
        leftOnPressed: () => Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.patronWristbandDetails,
          ModalRoute.withName(Routes.patronTabRoute),
        ),
        rightText: 'Top Up Band',
        rightOnPressed: () => Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.patronWristbandTopUp,
          ModalRoute.withName(Routes.patronTabRoute),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
