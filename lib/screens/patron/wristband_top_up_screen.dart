import 'package:eband/formatters/card_month_input_formatter.dart';
import 'package:eband/formatters/card_number_input_formatter.dart';
import 'package:eband/models/payment_card.dart';
import 'package:eband/models/user.dart';
import 'package:eband/models/wristband.dart';
import 'package:eband/router.dart';
import 'package:eband/screens/components/custom_app_bar.dart';
import 'package:eband/screens/components/rounded_button.dart';
import 'package:eband/services/firestore_database.dart';
import 'package:eband/utils/app_colors.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:eband/utils/app_text_styles.dart';
import 'package:eband/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class WristbandTopUpScreen extends StatefulWidget {
  @override
  _WristbandTopUpScreenState createState() => _WristbandTopUpScreenState();
}

class _WristbandTopUpScreenState extends State<WristbandTopUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int credits;
  bool _autoValidate = false;

  TextEditingController numberController = TextEditingController();
  final PaymentCard _paymentCard = PaymentCard();
  List<Widget> cardWidgets = <Widget>[];

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
    final User user = Provider.of<User>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar('Wristband Top Up'),
      body: SafeArea(
        minimum: kSafeArea,
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  verticalSpaceSmall(context),
                  Text(
                    'Amount of Credits',
                    style: AppTextStyles.headingTextPrimary,
                  ),
                  verticalSpaceTiny(context),
                  TextFormField(
                    onSaved: (val) => credits = int.parse(val),
                    keyboardType: TextInputType.number,
                    validator: Validators.validateCredits,
                    decoration: const InputDecoration(
                      labelText: 'Credits',
                    ),
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
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
                    style: AppTextStyles.headingTextPrimary,
                  ),
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
                          onSaved: (value) =>
                              _paymentCard.cvv = int.parse(value),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: screenWidth(context) * 0.4,
                        child: RoundedButton(
                          text: 'Top Up',
                          onPressed: () => topUp(user),
                        ),
                      ),
                      Container(
                        width: screenWidth(context) * 0.4,
                        child: RoundedButton(
                          color: AppColors.iconColor,
                          textColor: AppColors.textColor,
                          text: 'Cancel',
                          onPressed: () => Navigator.canPop(context)
                              ? Navigator.pop(context)
                              : Navigator.pushReplacementNamed(
                                  context, Routes.patronTabRoute),
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

  Future<void> topUp(User user) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final database = Provider.of<FirestoreDatabase>(context, listen: false);

      final Wristband wristband = user.wristband;
      wristband.credits = credits;

      await database.patronUpdateWristband(wristband);

      Navigator.canPop(context)
          ? Navigator.pop(context)
          : Navigator.pushReplacementNamed(context, Routes.patronTabRoute);
    } else {
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });
    }
  }
}
